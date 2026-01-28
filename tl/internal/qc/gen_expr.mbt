///|
/// Generates a NatExpr (natural number expression).
pub fn gen_nat_expr() -> @qc.Gen[@ast.NatExpr] {
  @qc.sized(fn(size) { gen_nat_expr_sized(size) })
}

///|
fn gen_nat_expr_sized(size : Int) -> @qc.Gen[@ast.NatExpr] {
  if size <= 0 {
    // Base cases only
    @qc.frequency([
      (3, @qc.small_int().fmap(fn(n) { @ast.NatExpr::Const(n.abs()) })),
      (2, gen_lower_ident().fmap(fn(s) { @ast.NatExpr::Var(s) })),
      (1, @qc.pure(@ast.NatExpr::Zero)),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (4, @qc.small_int().fmap(fn(n) { @ast.NatExpr::Const(n.abs()) })),
      (3, gen_lower_ident().fmap(fn(s) { @ast.NatExpr::Var(s) })),
      (1, @qc.pure(@ast.NatExpr::Zero)),
      (
        1,
        @qc.liftA2(
          fn(l, r) { @ast.NatExpr::Add(l, r) },
          gen_nat_expr_sized(smaller),
          gen_nat_expr_sized(smaller),
        ),
      ),
      (1, gen_nat_expr_sized(smaller).fmap(fn(x) { @ast.NatExpr::Succ(x) })),
    ])
  }
}

///|
/// Generates a TypeIdent.
pub fn gen_type_ident() -> @qc.Gen[@ast.TypeIdent] {
  @qc.liftA2(
    fn(ns, name) { @ast.TypeIdent::new(name~, ns?) },
    gen_namespace(),
    gen_upper_ident(),
  )
}

///|
/// Generates a simple TypeIdent (no namespace) for use in generic/variable contexts.
pub fn gen_simple_type_ident() -> @qc.Gen[@ast.TypeIdent] {
  gen_upper_ident().fmap(fn(name) { @ast.TypeIdent::simple(name) })
}

///|
/// Generates a TypeExpr.
pub fn gen_type_expr() -> @qc.Gen[@ast.TypeExpr] {
  @qc.sized(fn(size) { gen_type_expr_sized(size) })
}

///|
fn gen_type_expr_sized(size : Int) -> @qc.Gen[@ast.TypeExpr] {
  if size <= 0 {
    // Base cases: Ident, Var, Nat
    @qc.frequency([
      (5, gen_type_ident().fmap(fn(i) { @ast.TypeExpr::Ident(i) })),
      (2, gen_lower_ident().fmap(fn(s) { @ast.TypeExpr::Var(s) })),
      (1, @qc.pure(@ast.TypeExpr::Nat)),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (5, gen_type_ident().fmap(fn(i) { @ast.TypeExpr::Ident(i) })),
      (2, gen_lower_ident().fmap(fn(s) { @ast.TypeExpr::Var(s) })),
      (1, @qc.pure(@ast.TypeExpr::Nat)),
      (1, gen_type_expr_sized(smaller).fmap(fn(x) { @ast.TypeExpr::Bang(x) })),
      (
        1,
        gen_type_expr_sized(smaller).fmap(fn(x) { @ast.TypeExpr::Percent(x) }),
      ),
      (
        1,
        @qc.liftA2(
          fn(i, p) { @ast.TypeExpr::Apply(i, p) },
          gen_simple_type_ident(),
          gen_type_expr_array(smaller),
        ),
      ),
    ])
  }
}

///|
fn gen_type_expr_array(size : Int) -> @qc.Gen[Array[@ast.TypeExpr]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      let gen = gen_type_expr_sized(size / 2)
      @qc.Gen::new(fn(s, rs) { Array::makei(len, fn(_) { gen.run(s, rs) }) })
    }
  })
}

///|
/// Generates an Expr (Type or Nat).
pub fn gen_expr() -> @qc.Gen[@ast.Expr] {
  @qc.frequency([
    (3, gen_type_expr().fmap(fn(t) { @ast.Expr::Type(t) })),
    (1, gen_nat_expr().fmap(fn(n) { @ast.Expr::Nat(n) })),
  ])
}
