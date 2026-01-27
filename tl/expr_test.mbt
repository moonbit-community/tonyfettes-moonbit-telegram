///|
test "NatExpr const" {
  let expr = NatExpr::Const(42)
  inspect(expr, content="Const(42)")
}

///|
test "NatExpr add" {
  let n = NatExpr::Var("n")
  let dif = NatExpr::Var("dif")
  let sum = NatExpr::Add(n, dif)
  inspect(sum, content="Add(Var(\"n\"), Var(\"dif\"))")
}

///|
test "TypeIdent simple" {
  let ident = TypeIdent::simple("User")
  inspect(ident.name, content="User")
  assert_true(ident.ns is None)
}

///|
test "TypeIdent namespaced" {
  let ident = TypeIdent::namespaced("auth", "SentCode")
  inspect(ident.name, content="SentCode")
  inspect(ident.ns, content="Some(\"auth\")")
}

///|
test "TypeExpr Ident" {
  let expr = TypeExpr::Ident(TypeIdent::simple("User"))
  guard expr is Ident(ident) else { fail("expected Ident") }
  inspect(ident.name, content="User")
}

///|
test "TypeExpr Apply" {
  let vector = TypeIdent::simple("Vector")
  let int_type = TypeExpr::Ident(TypeIdent::simple("int"))
  let expr = TypeExpr::Apply(vector, [int_type])
  guard expr is Apply(ident, args) else { fail("expected Apply") }
  inspect(ident.name, content="Vector")
  inspect(args.length(), content="1")
}

///|
test "TypeExpr Bang" {
  let inner = TypeExpr::Ident(TypeIdent::simple("InputReplyTo"))
  let expr = TypeExpr::Bang(inner)
  guard expr is Bang(_) else { fail("expected Bang") }
}

///|
test "TypeExpr Percent" {
  let inner = TypeExpr::Apply(TypeIdent::simple("Vector"), [TypeExpr::Var("t")])
  let expr = TypeExpr::Percent(inner)
  guard expr is Percent(_) else { fail("expected Percent") }
}

///|
test "Expr Type" {
  let type_expr = TypeExpr::Nat
  let expr = Expr::Type(type_expr)
  guard expr is Type(TypeExpr::Nat) else { fail("expected Type(Nat)") }
}

///|
test "Expr Nat" {
  let nat_expr = NatExpr::Const(4)
  let expr = Expr::Nat(nat_expr)
  guard expr is Nat(NatExpr::Const(4)) else { fail("expected Nat(Const(4))") }
}
