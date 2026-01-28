///|
/// Compares two NatExpr values for equality.
pub fn nat_expr_equal(a : @ast.NatExpr, b : @ast.NatExpr) -> Bool {
  match (a, b) {
    (@ast.NatExpr::Const(n1), @ast.NatExpr::Const(n2)) => n1 == n2
    (@ast.NatExpr::Var(s1), @ast.NatExpr::Var(s2)) => s1 == s2
    (@ast.NatExpr::Add(l1, r1), @ast.NatExpr::Add(l2, r2)) =>
      nat_expr_equal(l1, l2) && nat_expr_equal(r1, r2)
    (@ast.NatExpr::Zero, @ast.NatExpr::Zero) => true
    (@ast.NatExpr::Succ(n1), @ast.NatExpr::Succ(n2)) => nat_expr_equal(n1, n2)
    _ => false
  }
}

///|
/// Compares two TypeIdent values for equality.
pub fn type_ident_equal(a : @ast.TypeIdent, b : @ast.TypeIdent) -> Bool {
  a.ns == b.ns && a.name == b.name
}

///|
/// Compares two TypeExpr values for equality.
pub fn type_expr_equal(a : @ast.TypeExpr, b : @ast.TypeExpr) -> Bool {
  match (a, b) {
    (@ast.TypeExpr::Ident(i1), @ast.TypeExpr::Ident(i2)) =>
      type_ident_equal(i1, i2)
    (@ast.TypeExpr::Bang(e1), @ast.TypeExpr::Bang(e2)) =>
      type_expr_equal(e1, e2)
    (@ast.TypeExpr::Percent(e1), @ast.TypeExpr::Percent(e2)) =>
      type_expr_equal(e1, e2)
    (@ast.TypeExpr::Apply(i1, p1), @ast.TypeExpr::Apply(i2, p2)) =>
      type_ident_equal(i1, i2) && type_expr_array_equal(p1, p2)
    (@ast.TypeExpr::Var(s1), @ast.TypeExpr::Var(s2)) => s1 == s2
    (@ast.TypeExpr::Nat, @ast.TypeExpr::Nat) => true
    _ => false
  }
}

///|
fn type_expr_array_equal(
  a : Array[@ast.TypeExpr],
  b : Array[@ast.TypeExpr],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(type_expr_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two Expr values for equality.
pub fn expr_equal(a : @ast.Expr, b : @ast.Expr) -> Bool {
  match (a, b) {
    (@ast.Expr::Type(t1), @ast.Expr::Type(t2)) => type_expr_equal(t1, t2)
    (@ast.Expr::Nat(n1), @ast.Expr::Nat(n2)) => nat_expr_equal(n1, n2)
    _ => false
  }
}

///|
fn expr_array_equal(a : Array[@ast.Expr], b : Array[@ast.Expr]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(expr_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two Conditional values for equality.
pub fn conditional_equal(a : @ast.Conditional, b : @ast.Conditional) -> Bool {
  a.var_name == b.var_name && a.bit_index == b.bit_index
}

///|
fn optional_conditional_equal(
  a : @ast.Conditional?,
  b : @ast.Conditional?,
) -> Bool {
  match (a, b) {
    (None, None) => true
    (Some(c1), Some(c2)) => conditional_equal(c1, c2)
    _ => false
  }
}

///|
/// Compares two NamedArg values for equality.
pub fn named_arg_equal(a : @ast.NamedArg, b : @ast.NamedArg) -> Bool {
  a.name == b.name &&
  optional_conditional_equal(a.conditional, b.conditional) &&
  a.bang == b.bang &&
  type_expr_equal(a.type_, b.type_)
}

///|
/// Compares two OptionalArg values for equality.
pub fn optional_arg_equal(a : @ast.OptionalArg, b : @ast.OptionalArg) -> Bool {
  string_array_equal(a.names, b.names) &&
  a.bang == b.bang &&
  type_expr_equal(a.type_, b.type_)
}

///|
fn string_array_equal(a : Array[String], b : Array[String]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if a[i] != b[i] {
      return false
    }
  }
  true
}

///|
fn optional_arg_array_equal(
  a : Array[@ast.OptionalArg],
  b : Array[@ast.OptionalArg],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(optional_arg_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two GroupedArg values for equality.
pub fn grouped_arg_equal(a : @ast.GroupedArg, b : @ast.GroupedArg) -> Bool {
  string_array_equal(a.names, b.names) &&
  a.bang == b.bang &&
  type_expr_equal(a.type_, b.type_)
}

///|
/// Compares two MultiplicityArg values for equality.
pub fn multiplicity_arg_equal(
  a : @ast.MultiplicityArg,
  b : @ast.MultiplicityArg,
) -> Bool {
  a.name == b.name &&
  nat_expr_equal(a.count, b.count) &&
  arg_array_equal(a.args, b.args)
}

///|
/// Compares two Arg values for equality.
pub fn arg_equal(a : @ast.Arg, b : @ast.Arg) -> Bool {
  match (a, b) {
    (@ast.Arg::Named(n1), @ast.Arg::Named(n2)) => named_arg_equal(n1, n2)
    (@ast.Arg::Optional(o1), @ast.Arg::Optional(o2)) =>
      optional_arg_equal(o1, o2)
    (@ast.Arg::Multiplicity(m1), @ast.Arg::Multiplicity(m2)) =>
      multiplicity_arg_equal(m1, m2)
    (@ast.Arg::Grouped(g1), @ast.Arg::Grouped(g2)) => grouped_arg_equal(g1, g2)
    (@ast.Arg::Anonymous(t1), @ast.Arg::Anonymous(t2)) =>
      type_expr_equal(t1, t2)
    _ => false
  }
}

///|
fn arg_array_equal(a : Array[@ast.Arg], b : Array[@ast.Arg]) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(arg_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two ResultType values for equality.
pub fn result_type_equal(a : @ast.ResultType, b : @ast.ResultType) -> Bool {
  type_ident_equal(a.type_ident, b.type_ident) &&
  expr_array_equal(a.params, b.params)
}

///|
/// Compares two Combinator values for equality (ignoring Span).
pub fn combinator_equal(a : @ast.Combinator, b : @ast.Combinator) -> Bool {
  a.ns == b.ns &&
  a.name == b.name &&
  a.id == b.id &&
  optional_arg_array_equal(a.opt_args, b.opt_args) &&
  arg_array_equal(a.args, b.args) &&
  result_type_equal(a.result, b.result)
  // Intentionally ignoring span field
}

///|
fn combinator_array_equal(
  a : Array[@ast.Combinator],
  b : Array[@ast.Combinator],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(combinator_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two FinalDeclData values for equality (ignoring Span).
pub fn final_decl_data_equal(
  a : @ast.FinalDeclData,
  b : @ast.FinalDeclData,
) -> Bool {
  type_ident_equal(a.type_ident, b.type_ident)
  // Intentionally ignoring span field
}

///|
/// Compares two FinalDecl values for equality (ignoring Span).
pub fn final_decl_equal(a : @ast.FinalDecl, b : @ast.FinalDecl) -> Bool {
  match (a, b) {
    (@ast.FinalDecl::New(d1), @ast.FinalDecl::New(d2)) =>
      final_decl_data_equal(d1, d2)
    (@ast.FinalDecl::Final(d1), @ast.FinalDecl::Final(d2)) =>
      final_decl_data_equal(d1, d2)
    (@ast.FinalDecl::Empty(d1), @ast.FinalDecl::Empty(d2)) =>
      final_decl_data_equal(d1, d2)
    _ => false
  }
}

///|
/// Compares two Declaration values for equality (ignoring Span).
pub fn declaration_equal(a : @ast.Declaration, b : @ast.Declaration) -> Bool {
  match (a, b) {
    (@ast.Declaration::Combinator(c1), @ast.Declaration::Combinator(c2)) =>
      combinator_equal(c1, c2)
    (@ast.Declaration::Final(f1), @ast.Declaration::Final(f2)) =>
      final_decl_equal(f1, f2)
    _ => false
  }
}

///|
fn declaration_array_equal(
  a : Array[@ast.Declaration],
  b : Array[@ast.Declaration],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(declaration_equal(a[i], b[i])) {
      return false
    }
  }
  true
}

///|
/// Compares two Schema values for equality (ignoring Span in nested structures).
pub fn schema_equal(a : @ast.Schema, b : @ast.Schema) -> Bool {
  declaration_array_equal(a.types, b.types) &&
  combinator_array_equal(a.functions, b.functions)
  // Intentionally ignoring comments as they involve Span
}
