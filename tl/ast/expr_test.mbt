///|
test "TypeIdent simple" {
  let ident = TypeIdent::simple(UpperIdent::new(value="User"))
  inspect(ident.name.value, content="User")
  assert_true(ident.ns is None)
}

///|
test "TypeIdent namespaced" {
  let ident = TypeIdent::namespaced(LowerIdent::new(value="auth"), UpperIdent::new(value="SentCode"))
  inspect(ident.name.value, content="SentCode")
  inspect(ident.ns.map(fn(x) { x.value }), content="Some(\"auth\")")
}

///|
test "Term Ident" {
  let term = Term::Ident(TypeIdent::simple(UpperIdent::new(value="User")))
  guard term is Ident(ident) else { fail("expected Ident") }
  inspect(ident.name.value, content="User")
}

///|
test "Term Apply" {
  let vector = TypeIdent::simple(UpperIdent::new(value="Vector"))
  let arg = Expr::new(items=[Subexpr::Term(Term::Var(LowerIdent::new(value="t")))])
  let term = Term::Apply(vector, [arg])
  guard term is Apply(ident, params) else { fail("expected Apply") }
  inspect(ident.name.value, content="Vector")
  inspect(params.length(), content="1")
}

///|
test "Subexpr add" {
  let sub = Subexpr::AddRight(Subexpr::Term(Term::Var(LowerIdent::new(value="n"))), 1)
  guard sub is AddRight(_, 1) else { fail("expected AddRight") }
}

///|
test "Expr sequence" {
  let expr = Expr::new(items=[
    Subexpr::Term(Term::Var(LowerIdent::new(value="A"))),
    Subexpr::Term(Term::Var(LowerIdent::new(value="B"))),
  ])
  inspect(expr.items.length(), content="2")
}
