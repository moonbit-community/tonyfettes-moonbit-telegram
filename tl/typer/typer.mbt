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
    Some(id) => id
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
    Some(id) => id
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
  // Collect bound type variables from opt_args
  let type_vars : Map[String, Unit] = {}
  let nat_vars : Map[String, Unit] = {}
  // Track which optional parameters are used (only for opt_args, not flags fields)
  let type_var_used : Map[String, Bool] = {}
  let nat_var_used : Map[String, Bool] = {}
  for opt in c.opt_args {
    for name in opt.names {
      if opt.type_ is @ast.TypeExpr::Nat {
        nat_vars[name] = ()
        nat_var_used[name] = false
      } else {
        type_vars[name] = ()
        type_var_used[name] = false
      }
    }
  }

  // Collect nat variables from # fields (flags fields)
  let flags_fields : Map[String, Unit] = {}
  for arg in c.args {
    match arg {
      @ast.Arg::Named(named) =>
        if named.type_ is @ast.TypeExpr::Nat {
          flags_fields[named.name] = ()
          nat_vars[named.name] = ()
        }
      _ => ()
    }
  }

  // Resolve opt_args types
  for opt in c.opt_args {
    resolve_type_expr(
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
/// Resolves a type expression.
fn resolve_type_expr(
  table : SymbolTable,
  expr : @ast.TypeExpr,
  span : @ast.Span,
  type_vars : Map[String, Unit],
  nat_vars : Map[String, Unit],
  type_var_used : Map[String, Bool],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match expr {
    @ast.TypeExpr::Ident(ident) => {
      let name = type_ident_full_name(ident)
      // Check if it's a builtin, declared type, or type variable
      if not(
          table.builtins.contains(name) ||
          table.types.contains(name) ||
          type_vars.contains(name),
        ) {
        raise UndefinedType(pos=span, name~)
      }
    }
    @ast.TypeExpr::Percent(inner) =>
      resolve_type_expr(
        table, inner, span, type_vars, nat_vars, type_var_used, nat_var_used,
      )
    @ast.TypeExpr::Apply(ident, params) => {
      let name = type_ident_full_name(ident)
      if not(table.builtins.contains(name) || table.types.contains(name)) {
        raise UndefinedType(pos=span, name~)
      }
      for param in params {
        resolve_type_expr(
          table, param, span, type_vars, nat_vars, type_var_used, nat_var_used,
        )
      }
    }
    @ast.TypeExpr::Var(name) => {
      // Variables can be type variables, nat variables, or built-in types
      // Due to parser ambiguity, nat variables might appear as type vars
      if not(
          type_vars.contains(name) ||
          nat_vars.contains(name) ||
          table.builtins.contains(name),
        ) {
        raise UnboundTypeVariable(pos=span, variable=name)
      }
      // Mark variable as used
      if type_var_used.contains(name) {
        type_var_used[name] = true
      }
      if nat_var_used.contains(name) {
        nat_var_used[name] = true
      }
    }
    @ast.TypeExpr::Nat => ()
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
        if not(flags_fields.contains(cond.var_name)) {
          raise UndefinedFlagsField(
            pos=span,
            conditional=cond.var_name,
            ctor="",
          )
        }
      }
      resolve_type_expr(
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
      resolve_nat_expr(mult.count, span, nat_vars, nat_var_used)
      // Resolve nested args
      for nested in mult.args {
        resolve_arg(
          table, nested, span, type_vars, nat_vars, flags_fields, type_var_used,
          nat_var_used,
        )
      }
    }
    @ast.Arg::Grouped(grouped) =>
      resolve_type_expr(
        table,
        grouped.type_,
        span,
        type_vars,
        nat_vars,
        type_var_used,
        nat_var_used,
      )
    @ast.Arg::Anonymous(anon) =>
      resolve_type_expr(
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
/// Resolves a natural number expression.
fn resolve_nat_expr(
  expr : @ast.NatExpr,
  span : @ast.Span,
  nat_vars : Map[String, Unit],
  nat_var_used : Map[String, Bool],
) -> Unit raise TLTypeError {
  match expr {
    @ast.NatExpr::Const(_) => ()
    @ast.NatExpr::Var(name) => {
      if not(nat_vars.contains(name)) {
        raise UnboundNatVariable(pos=span, variable=name)
      }
      // Mark variable as used
      if nat_var_used.contains(name) {
        nat_var_used[name] = true
      }
    }
    @ast.NatExpr::Add(left, right) => {
      resolve_nat_expr(left, span, nat_vars, nat_var_used)
      resolve_nat_expr(right, span, nat_vars, nat_var_used)
    }
    @ast.NatExpr::Zero => () // Peano zero, no validation needed
    @ast.NatExpr::Succ(inner) =>
      // Peano successor, recursively validate inner
      resolve_nat_expr(inner, span, nat_vars, nat_var_used)
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
    match param {
      @ast.Expr::Type(t) =>
        resolve_type_expr(
          table, t, span, type_vars, nat_vars, type_var_used, nat_var_used,
        )
      @ast.Expr::Nat(n) => resolve_nat_expr(n, span, nat_vars, nat_var_used)
    }
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
