///|
/// Type identifier with optional namespace.
pub(all) struct TypeIdent {
  ns : LowerIdent? // e.g., "auth" in auth.SentCode
  name : UpperIdent // e.g., "SentCode" or "User"
} derive(Show)

///|
pub impl Eq for TypeIdent with equal(self, other) {
  self.ns == other.ns && self.name == other.name
}

///|
/// Creates a new TypeIdent with optional namespace.
pub fn TypeIdent::new(name~ : UpperIdent, ns? : LowerIdent) -> TypeIdent {
  { ns, name }
}

///|
/// Creates a simple TypeIdent without namespace.
pub fn TypeIdent::simple(name : UpperIdent) -> TypeIdent {
  { ns: None, name }
}

///|
/// Creates a TypeIdent with a namespace.
pub fn TypeIdent::namespaced(ns : LowerIdent, name : UpperIdent) -> TypeIdent {
  { ns: Some(ns), name }
}

///|
/// Term in TL expressions (type-term/nat-term).
pub(all) enum Term {
  Paren(Expr) // (expr)
  Ident(TypeIdent) // type-ident (including "#")
  Var(LowerIdent) // var-ident
  NatConst(Int) // nat-const
  Percent(Term) // % term
  Apply(TypeIdent, Array[Expr]) // type-ident<expr, ...>
} derive(Show)

///|
pub impl Eq for Term with equal(self, other) {
  match (self, other) {
    (Paren(e1), Paren(e2)) => e1 == e2
    (Ident(i1), Ident(i2)) => i1 == i2
    // Special case: Ident without namespace equals Var
    (Ident(i1), Var(s2)) => i1.ns == None && i1.name.value == s2.value
    (Var(s1), Var(s2)) => s1 == s2
    (Var(s1), Ident(i2)) => i2.ns == None && i2.name.value == s1.value
    (NatConst(n1), NatConst(n2)) => n1 == n2
    (Percent(t1), Percent(t2)) => t1 == t2
    (Apply(i1, p1), Apply(i2, p2)) => i1 == i2 && p1 == p2
    _ => false
  }
}

///|
/// Subexpression with optional nat-const addition.
pub(all) enum Subexpr {
  Term(Term)
  AddLeft(Int, Subexpr) // nat-const + subexpr
  AddRight(Subexpr, Int) // subexpr + nat-const
} derive(Show)

///|
pub impl Eq for Subexpr with equal(self, other) {
  match (self, other) {
    (Term(t1), Term(t2)) => t1 == t2
    (AddLeft(n1, r1), AddLeft(n2, r2)) => n1 == n2 && r1 == r2
    (AddRight(l1, n1), AddRight(l2, n2)) => n1 == n2 && l1 == l2
    _ => false
  }
}

///|
/// Expression: sequence of subexpressions (application by juxtaposition).
pub(all) struct Expr {
  items : Array[Subexpr]
} derive(Show)

///|
pub impl Eq for Expr with equal(self, other) {
  self.items == other.items
}

///|
/// Creates a new expression from subexpressions.
pub fn Expr::new(items~ : Array[Subexpr]) -> Expr {
  { items, }
}
