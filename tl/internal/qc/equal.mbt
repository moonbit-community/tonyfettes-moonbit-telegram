///|
/// Compares two TypeIdent values for equality.
pub fn type_ident_equal(a : @ast.TypeIdent, b : @ast.TypeIdent) -> Bool {
  a.ns == b.ns && a.name == b.name
}

///|
/// Compares two Term values for equality.
pub fn term_equal(a : @ast.Term, b : @ast.Term) -> Bool {
  match (a, b) {
    (@ast.Term::Paren(e1), @ast.Term::Paren(e2)) => expr_equal(e1, e2)
    (@ast.Term::Ident(i1), @ast.Term::Ident(i2)) => type_ident_equal(i1, i2)
    (@ast.Term::Ident(i1), @ast.Term::Var(s2)) => i1.ns == None && i1.name == s2
    (@ast.Term::Var(s1), @ast.Term::Var(s2)) => s1 == s2
    (@ast.Term::Var(s1), @ast.Term::Ident(i2)) => i2.ns == None && i2.name == s1
    (@ast.Term::NatConst(n1), @ast.Term::NatConst(n2)) => n1 == n2
    (@ast.Term::Percent(t1), @ast.Term::Percent(t2)) => term_equal(t1, t2)
    (@ast.Term::Apply(i1, p1), @ast.Term::Apply(i2, p2)) =>
      type_ident_equal(i1, i2) && expr_array_equal(p1, p2)
    _ => false
  }
}

///|
/// Compares two Subexpr values for equality.
pub fn subexpr_equal(a : @ast.Subexpr, b : @ast.Subexpr) -> Bool {
  match (a, b) {
    (@ast.Subexpr::Term(t1), @ast.Subexpr::Term(t2)) => term_equal(t1, t2)
    (@ast.Subexpr::AddLeft(n1, r1), @ast.Subexpr::AddLeft(n2, r2)) =>
      n1 == n2 && subexpr_equal(r1, r2)
    (@ast.Subexpr::AddRight(l1, n1), @ast.Subexpr::AddRight(l2, n2)) =>
      n1 == n2 && subexpr_equal(l1, l2)
    _ => false
  }
}

///|
fn type_ident_to_string(ident : @ast.TypeIdent) -> String {
  if ident.ns is Some(ns) {
    ns + "." + ident.name
  } else {
    ident.name
  }
}

///|
fn term_to_string(term : @ast.Term) -> String {
  match term {
    @ast.Term::Paren(expr) => "(" + expr_to_string(expr) + ")"
    @ast.Term::Ident(ident) => type_ident_to_string(ident)
    @ast.Term::Var(name) => name
    @ast.Term::NatConst(n) => n.to_string()
    @ast.Term::Percent(inner) => "%" + term_to_string(inner)
    @ast.Term::Apply(ident, params) => {
      let sb = StringBuilder::new()
      sb.write_string(type_ident_to_string(ident))
      sb.write_char('<')
      for i, p in params {
        if i > 0 {
          sb.write_string(", ")
        }
        sb.write_string(expr_to_string(p))
      }
      sb.write_char('>')
      sb.to_string()
    }
  }
}

///|
fn subexpr_to_string(expr : @ast.Subexpr) -> String {
  match expr {
    @ast.Subexpr::Term(term) => term_to_string(term)
    @ast.Subexpr::AddLeft(n, right) =>
      n.to_string() + "+" + subexpr_to_string(right)
    @ast.Subexpr::AddRight(left, n) =>
      subexpr_to_string(left) + "+" + n.to_string()
  }
}

///|
fn expr_to_string(expr : @ast.Expr) -> String {
  let sb = StringBuilder::new()
  for i, item in expr.items {
    if i > 0 {
      sb.write_char(' ')
    }
    sb.write_string(subexpr_to_string(item))
  }
  sb.to_string()
}

///|
/// Compares two Expr values for equality.
pub fn expr_equal(a : @ast.Expr, b : @ast.Expr) -> Bool {
  subexpr_array_equal(a.items, b.items)
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
fn subexpr_array_equal(
  a : Array[@ast.Subexpr],
  b : Array[@ast.Subexpr],
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  for i = 0; i < a.length(); i = i + 1 {
    if not(subexpr_equal(a[i], b[i])) {
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
  term_equal(a.type_, b.type_)
}

///|
/// Compares two OptionalArg values for equality.
pub fn optional_arg_equal(a : @ast.OptionalArg, b : @ast.OptionalArg) -> Bool {
  string_array_equal(a.names, b.names) &&
  a.bang == b.bang &&
  expr_equal(a.type_, b.type_)
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
  term_equal(a.type_, b.type_)
}

///|
/// Compares two AnonymousArg values for equality.
pub fn anonymous_arg_equal(
  a : @ast.AnonymousArg,
  b : @ast.AnonymousArg,
) -> Bool {
  a.bang == b.bang && term_equal(a.type_, b.type_)
}

///|
/// Compares two MultiplicityArg values for equality.
pub fn multiplicity_arg_equal(
  a : @ast.MultiplicityArg,
  b : @ast.MultiplicityArg,
) -> Bool {
  a.name == b.name &&
  term_equal(a.count, b.count) &&
  arg_array_equal(a.args, b.args)
}

///|
/// Compares two Arg values for equality.
pub fn arg_equal(a : @ast.Arg, b : @ast.Arg) -> Bool {
  match (a, b) {
    (@ast.Arg::Named(n1), @ast.Arg::Named(n2)) => named_arg_equal(n1, n2)
    (@ast.Arg::Multiplicity(m1), @ast.Arg::Multiplicity(m2)) =>
      multiplicity_arg_equal(m1, m2)
    (@ast.Arg::Grouped(g1), @ast.Arg::Grouped(g2)) => grouped_arg_equal(g1, g2)
    (@ast.Arg::Anonymous(a1), @ast.Arg::Anonymous(a2)) =>
      anonymous_arg_equal(a1, a2)
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
  subexpr_array_equal(a.params, b.params)
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
