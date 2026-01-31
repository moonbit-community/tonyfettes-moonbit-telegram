///|
/// Type checks a TL schema and builds a symbol table.
///
/// Returns a symbol table containing all resolved types, constructors, and functions,
/// or raises a TLTypeError if validation fails.
pub fn type_schema(schema : @ast.Schema) -> SymbolTable raise TLTypeError {
  let table = SymbolTable::new()

  // Phase 1: Collect all type declarations and check for duplicate IDs/names
  collect_declarations(table, schema)

  // Phase 2: Resolve all type references
  resolve_schema(table, schema)
  table
}

///|
/// Phase 1: Collect all declarations and build initial symbol table.
fn collect_declarations(
  table : SymbolTable,
  schema : @ast.Schema,
) -> Unit raise TLTypeError {
  // Process type declarations
  for decl in schema.types {
    match decl {
      @ast.Declaration::Combinator(c) => collect_combinator(table, c)
      @ast.Declaration::Final(f) => collect_final(table, f)
    }
  }

  // Process function declarations
  for f in schema.functions {
    collect_function(table, f)
  }
}

///|
/// Collects a combinator declaration.
fn collect_combinator(
  table : SymbolTable,
  c : @ast.Combinator,
) -> Unit raise TLTypeError {
  let full_name = combinator_full_name(c)

  // Check for duplicate constructor name
  if table.constructors.contains(full_name) ||
    table.functions.contains(full_name) {
    raise DuplicateConstructorName(pos=c.span, name=full_name)
  }
  table.constructors[full_name] = c

  // Register constructor ID
  // Compute ID from CRC32 if not explicitly provided
  // Note: Telegram schema allows duplicate IDs where "Prefix" versions are
  // placeholders that get overwritten by the real declarations
  let id = match c.id {
    Some(id) => id.value
    None => {
      let normalized = normalize_combinator(c)
      crc32(normalized)
    }
  }
  table.ids[id] = c

  // Register the result type
  let type_name = type_ident_full_name(c.result.type_ident)
  if table.types.get(type_name) is Some(resolved) {
    // Check if the type is marked as final or empty
    if resolved.is_final {
      raise FinalTypeViolation(pos=c.span, type_name~)
    }
    if resolved.is_empty {
      raise EmptyTypeViolation(pos=c.span, type_name~)
    }
    // Add constructor to existing type
    resolved.constructors.push(c)
  } else {
    // Create new resolved type
    table.types[type_name] = ResolvedType::new(name=c.result.type_ident, constructors=[
      c,
    ])
  }
}

///|
/// Collects a function declaration.
fn collect_function(
  table : SymbolTable,
  f : @ast.Combinator,
) -> Unit raise TLTypeError {
  let full_name = combinator_full_name(f)

  // Check for duplicate function name (and cross-section collisions)
  if table.functions.contains(full_name) ||
    table.constructors.contains(full_name) {
    raise DuplicateConstructorName(pos=f.span, name=full_name)
  }
  table.functions[full_name] = f

  // Register function ID
  // Compute ID from CRC32 if not explicitly provided
  let id = match f.id {
    Some(id) => id.value
    None => {
      let normalized = normalize_combinator(f)
      crc32(normalized)
    }
  }
  table.ids[id] = f
}

///|
/// Collects a final declaration.
fn collect_final(
  table : SymbolTable,
  f : @ast.FinalDecl,
) -> Unit raise TLTypeError {
  let (data, is_new, is_final, is_empty) = match f {
    @ast.FinalDecl::New(data) => (data, true, false, false)
    @ast.FinalDecl::Final(data) => (data, false, true, false)
    @ast.FinalDecl::Empty(data) => (data, false, false, true)
  }
  let ident = data.type_ident
  let type_name = type_ident_full_name(ident)
  if table.types.get(type_name) is Some(resolved) {
    // For New declarations, check that no constructors exist yet
    if is_new && resolved.constructors.length() > 0 {
      raise NewTypeViolation(pos=data.span, type_name~)
    }
    // Update existing type
    table.types[type_name] = {
      ..resolved,
      is_final: resolved.is_final || is_final,
      is_empty: resolved.is_empty || is_empty,
    }
  } else {
    // Create new type with just the flags
    table.types[type_name] = ResolvedType::new(name=ident, is_final~, is_empty~)
  }
}

///|
/// Phase 2: Resolve all type references in the schema.
fn resolve_schema(
  table : SymbolTable,
  schema : @ast.Schema,
) -> Unit raise TLTypeError {
  // Resolve type declarations
  for decl in schema.types {
    if decl is @ast.Declaration::Combinator(c) {
      resolve_combinator(table, c, false)
    }
  }

  // Resolve function declarations
  for f in schema.functions {
    resolve_combinator(table, f, true)
  }
}

///|
/// Resolves all type references in a combinator.
fn resolve_combinator(
  table : SymbolTable,
  c : @ast.Combinator,
  check_result_type : Bool,
) -> Unit raise TLTypeError {
  // Collect bound type/nat variables from opt_args
  let type_vars : Map[String, Unit] = {}
  let nat_vars : Map[String, Unit] = {}
  // Track which optional parameters are used (only for opt_args, not flags fields)
  let type_var_used : Map[String, Bool] = {}
  let nat_var_used : Map[String, Bool] = {}
  for opt in c.opt_args {
    let is_nat = is_hash_expr(opt.type_)
    for name in opt.names {
      if is_nat {
        nat_vars[name.value] = ()
        nat_var_used[name.value] = false
      } else {
        type_vars[name.value] = ()
        type_var_used[name.value] = false
      }
    }
  }

  // Collect nat variables from # fields (flags fields)
  let flags_fields : Map[String, Unit] = {}
  for arg in c.args {
    match arg {
      @ast.Arg::Named(named) =>
        if is_hash_term(named.type_) {
          flags_fields[named.name.value] = ()
          nat_vars[named.name.value] = ()
        }
      _ => ()
    }
  }

  // Resolve opt_args types
  for opt in c.opt_args {
    resolve_expr_auto(
      table,
      opt.type_,
      c.span,
      type_vars,
      nat_vars,
      type_var_used,
      nat_var_used,
    )
  }

  // Resolve args
  for arg in c.args {
    resolve_arg(
      table,
      arg,
      c.span,
      type_vars,
      nat_vars,
      flags_fields,
      type_var_used,
      nat_var_used,
    )
  }

  // Resolve result type
  resolve_result_type(
    table,
    c.result,
    c.span,
    type_vars,
    nat_vars,
    type_var_used,
    nat_var_used,
  )
  if check_result_type {
    validate_result_type_name(table, c.result, c.span, type_vars)
  }

  // Check that all optional parameters are used
  for entry in type_var_used {
    if not(entry.1) {
      raise UnusedOptionalParameter(pos=c.span, variable=entry.0)
    }
  }
  for entry in nat_var_used {
    if not(entry.1) {
      raise UnusedOptionalParameter(pos=c.span, variable=entry.0)
    }
  }
}

///|
/// Resolves an argument.
fn resolve_arg(
  table : SymbolTable,
  arg : @ast.Arg,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  flags_fields : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match arg {
    @ast.Arg::Named(named) => {
      // Check conditional field reference
      if named.conditional is Some(cond) {
        if not(flags_fields.contains(cond.var_name.value)) {
          raise UndefinedFlagsField(
            pos=span,
            conditional=cond.var_name.value,
            ctor="",
          )
        }
      }
      resolve_term_type(
        table,
        named.type_,
        span,
        type_vars,
        nat_vars,
        type_var_used,
        nat_var_used,
      )
    }
    @ast.Arg::Multiplicity(mult) => {
      // Check multiplicity count variable
      resolve_term_nat(table, mult.count, span, nat_vars, nat_var_used)
      // Resolve nested args
      for nested in mult.args {
        resolve_arg(
          table, nested, span, type_vars, nat_vars, flags_fields, type_var_used,
          nat_var_used,
        )
      }
    }
    @ast.Arg::Grouped(grouped) =>
      resolve_term_type(
        table,
        grouped.type_,
        span,
        type_vars,
        nat_vars,
        type_var_used,
        nat_var_used,
      )
    @ast.Arg::Anonymous(anon) =>
      resolve_term_type(
        table,
        anon.type_,
        span,
        type_vars,
        nat_vars,
        type_var_used,
        nat_var_used,
      )
  }
}

///|
/// Resolves a result type.
fn resolve_result_type(
  table : SymbolTable,
  result : @ast.ResultType,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  // Mark type variable as used if the result type name is a type variable
  // (e.g., in `{X:Type} query:!X = X;` the result type X should mark X as used)
  let type_name = type_ident_full_name(result.type_ident)
  if type_var_used.contains(type_name) {
    type_var_used[type_name] = true
  }

  // Resolve params
  for param in result.params {
    if subexpr_has_nat_hint(param, nat_vars) {
      resolve_subexpr_nat(table, param, span, nat_vars, nat_var_used)
    } else {
      resolve_subexpr_type(
        table, param, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    }
  }
}

///|
/// Returns true if a term is the builtin "#" type.
fn is_hash_term(term : @ast.Term) -> Bool {
  match term {
    @ast.Term::Ident(ident) => ident.ns is None && ident.name.value == "#"
    _ => false
  }
}

///|
/// Returns true if an expression is exactly "#".
fn is_hash_expr(expr : @ast.Expr) -> Bool {
  match expr.items {
    [@ast.Subexpr::Term(term)] => is_hash_term(term)
    _ => false
  }
}

///|
/// Returns true if a name starts with an uppercase ASCII letter.
fn is_upper_name(name : String) -> Bool {
  if name.length() == 0 {
    false
  } else {
    let c : UInt16 = name[0]
    c >= ('A' : UInt16) && c <= ('Z' : UInt16)
  }
}

///|
/// Checks whether a term hints a nat expression (constants, O/S, or nat vars).
fn term_has_nat_hint(term : @ast.Term, nat_vars : Map[String, Unit]) -> Bool {
  match term {
    @ast.Term::NatConst(_) => true
    @ast.Term::Var(name) =>
      nat_vars.contains(name.value) || name.value == "O" || name.value == "S"
    @ast.Term::Ident(ident) =>
      ident.ns is None &&
      (ident.name.value == "O" || ident.name.value == "S" || nat_vars.contains(ident.name.value))
    @ast.Term::Apply(ident, _) =>
      ident.ns is None && (ident.name.value == "O" || ident.name.value == "S")
    @ast.Term::Paren(expr) => expr_has_nat_hint(expr, nat_vars)
    @ast.Term::Percent(_) => false
  }
}

///|
/// Checks whether a subexpression hints a nat expression.
fn subexpr_has_nat_hint(
  expr : @ast.Subexpr,
  nat_vars : Map[String, Unit],
) -> Bool {
  match expr {
    @ast.Subexpr::AddLeft(_, _) => true
    @ast.Subexpr::AddRight(_, _) => true
    @ast.Subexpr::Term(term) => term_has_nat_hint(term, nat_vars)
  }
}

///|
/// Checks whether any subexpression in an expression hints nat.
fn expr_has_nat_hint(expr : @ast.Expr, nat_vars : Map[String, Unit]) -> Bool {
  for item in expr.items {
    if subexpr_has_nat_hint(item, nat_vars) {
      return true
    }
  }
  false
}

///|
/// Resolves a type expression, disambiguating nat subexpressions by syntax hints.
fn resolve_expr_auto(
  table : SymbolTable,
  expr : @ast.Expr,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  for item in expr.items {
    if subexpr_has_nat_hint(item, nat_vars) {
      resolve_subexpr_nat(table, item, span, nat_vars, nat_var_used)
    } else {
      resolve_subexpr_type(
        table, item, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    }
  }
}

///|
/// Resolves a nat expression.
fn resolve_expr_nat(
  table : SymbolTable,
  expr : @ast.Expr,
  span : @ast.Span,
  nat_vars : Map[String, Unit],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  for item in expr.items {
    resolve_subexpr_nat(table, item, span, nat_vars, nat_var_used)
  }
}

///|
/// Resolves a subexpression as a type expression.
fn resolve_subexpr_type(
  table : SymbolTable,
  expr : @ast.Subexpr,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match expr {
    @ast.Subexpr::Term(term) =>
      resolve_term_type(
        table, term, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    @ast.Subexpr::AddLeft(_, _) | @ast.Subexpr::AddRight(_, _) =>
      resolve_subexpr_nat(table, expr, span, nat_vars, nat_var_used)
  }
}

///|
/// Resolves a subexpression as a nat expression.
fn resolve_subexpr_nat(
  table : SymbolTable,
  expr : @ast.Subexpr,
  span : @ast.Span,
  nat_vars : Map[String, Unit],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match expr {
    @ast.Subexpr::AddLeft(_, right) =>
      resolve_subexpr_nat(table, right, span, nat_vars, nat_var_used)
    @ast.Subexpr::AddRight(left, _) =>
      resolve_subexpr_nat(table, left, span, nat_vars, nat_var_used)
    @ast.Subexpr::Term(term) =>
      resolve_term_nat(table, term, span, nat_vars, nat_var_used)
  }
}

///|
/// Resolves a term as a type expression.
fn resolve_term_type(
  table : SymbolTable,
  term : @ast.Term,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match term {
    @ast.Term::Paren(expr) =>
      resolve_expr_auto(
        table, expr, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    @ast.Term::Percent(inner) =>
      resolve_term_type(
        table, inner, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    @ast.Term::Apply(ident, params) => {
      let name = type_ident_full_name(ident)
      if not(table.builtins.contains(name) || table.types.contains(name)) {
        raise UndefinedType(pos=span, name~)
      }
      for param in params {
        resolve_expr_auto(
          table, param, span, type_vars, nat_vars, type_var_used, nat_var_used,
        )
      }
    }
    @ast.Term::Ident(ident) => {
      let name = type_ident_full_name(ident)
      if ident.ns is None && type_vars.contains(name) {
        type_var_used[name] = true
      } else if ident.ns is None && nat_vars.contains(name) {
        nat_var_used[name] = true
      } else if not(table.builtins.contains(name) || table.types.contains(name)) {
        raise UndefinedType(pos=span, name~)
      }
    }
    @ast.Term::Var(name) =>
      if type_vars.contains(name.value) {
        type_var_used[name.value] = true
      } else if nat_vars.contains(name.value) {
        nat_var_used[name.value] = true
      } else if table.builtins.contains(name.value) || table.types.contains(name.value) {
        ()
      } else if is_upper_name(name.value) {
        raise UndefinedType(pos=span, name=name.value)
      } else {
        raise UnboundTypeVariable(pos=span, variable=name.value)
      }
    @ast.Term::NatConst(_) => ()
  }
}

///|
/// Resolves a term as a nat expression.
fn resolve_term_nat(
  table : SymbolTable,
  term : @ast.Term,
  span : @ast.Span,
  nat_vars : Map[String, Unit],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match term {
    @ast.Term::Paren(expr) =>
      resolve_expr_nat(table, expr, span, nat_vars, nat_var_used)
    @ast.Term::NatConst(_) => ()
    @ast.Term::Var(name) =>
      if nat_vars.contains(name.value) {
        nat_var_used[name.value] = true
      } else if name.value == "O" || name.value == "S" {
        ()
      } else {
        raise UnboundNatVariable(pos=span, variable=name.value)
      }
    @ast.Term::Ident(ident) =>
      if ident.ns is None && (ident.name.value == "O" || ident.name.value == "S") {
        ()
      } else {
        let name = type_ident_full_name(ident)
        raise UndefinedType(pos=span, name~)
      }
    @ast.Term::Apply(ident, params) =>
      if ident.ns is None && (ident.name.value == "O" || ident.name.value == "S") {
        for param in params {
          resolve_expr_nat(table, param, span, nat_vars, nat_var_used)
        }
      } else {
        let name = type_ident_full_name(ident)
        raise UndefinedType(pos=span, name~)
      }
    @ast.Term::Percent(_) => raise UndefinedType(pos=span, name="%")
  }
}

///|
/// Ensures function result type names refer to declared types or bound type variables.
fn validate_result_type_name(
  table : SymbolTable,
  result : @ast.ResultType,
  span : @ast.Span,
  type_vars : Map[String, Unit],
) -> Unit raise TLTypeError {
  let name = type_ident_full_name(result.type_ident)
  if not(
      table.builtins.contains(name) ||
      table.types.contains(name) ||
      type_vars.contains(name),
    ) {
    raise UndefinedType(pos=span, name~)
  }
}
