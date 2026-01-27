///|
/// Natural number expressions for type arithmetic.
pub(all) enum NatExpr {
  Const(Int) // literal like 4, 8
  Var(String) // variable like n, dif
  Add(NatExpr, NatExpr) // addition like n+dif
} derive(Show, Eq)

///|
/// Type identifier with optional namespace.
pub(all) struct TypeIdent {
  ns : String? // e.g., "auth" in auth.SentCode
  name : String // e.g., "SentCode" or "User"
} derive(Show, Eq)

///|
/// Creates a new TypeIdent with optional namespace.
pub fn TypeIdent::new(name~ : String, ns? : String) -> TypeIdent {
  { ns, name }
}

///|
/// Creates a simple TypeIdent without namespace.
pub fn TypeIdent::simple(name : String) -> TypeIdent {
  { ns: None, name }
}

///|
/// Creates a TypeIdent with a namespace.
pub fn TypeIdent::namespaced(ns : String, name : String) -> TypeIdent {
  { ns: Some(ns), name }
}

///|
/// Type expressions.
pub(all) enum TypeExpr {
  // Named type reference (bare or boxed based on case)
  Ident(TypeIdent)
  // ! prefix for bare serialization in args
  Bang(TypeExpr)
  // % prefix for bare type reference
  Percent(TypeExpr)
  // Generic application: Vector<int>, Tuple<t, n>
  Apply(TypeIdent, Array[TypeExpr])
  // Variable reference in generic context
  Var(String)
  // Natural number type (#)
  Nat
} derive(Show, Eq)

///|
/// Generic expression (type or nat).
pub(all) enum Expr {
  Type(TypeExpr)
  Nat(NatExpr)
} derive(Show, Eq)
