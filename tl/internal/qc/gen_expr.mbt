///|
fn abs_int(n : Int) -> Int {
  if n < 0 {
    -n
  } else {
    n
  }
}

///|
fn subexpr_starts_with_nat_const(expr : @ast.Subexpr) -> Bool {
  match expr {
    @ast.Subexpr::Term(@ast.Term::NatConst(_)) => true
    @ast.Subexpr::Term(_) => false
    @ast.Subexpr::AddLeft(_, _) => true
    @ast.Subexpr::AddRight(left, _) => subexpr_starts_with_nat_const(left)
  }
}

///|
fn wrap_add_right_left(expr : @ast.Subexpr) -> @ast.Subexpr {
  if subexpr_starts_with_nat_const(expr) {
    @ast.Subexpr::Term(@ast.Term::Paren(@ast.Expr::new(items=[expr])))
  } else {
    expr
  }
}

///|
/// Generates a TypeIdent suitable for a bare term (uppercase when no namespace).
fn gen_term_type_ident() -> @qc.Gen[@ast.TypeIdent] {
  gen_namespace().bind(fn(ns) {
    match ns {
      None => gen_upper_ident().fmap(fn(name) { @ast.TypeIdent::simple(name) })
      Some(ns_name) =>
        gen_upper_ident().fmap(fn(name) {
          @ast.TypeIdent::new(name~, ns=ns_name)
        })
    }
  })
}

///|
/// Generates a TypeIdent.
pub fn gen_type_ident() -> @qc.Gen[@ast.TypeIdent] {
  @qc.liftA2(
    fn(ns, name) { @ast.TypeIdent::new(name~, ns?) },
    gen_namespace(),
    gen_type_name(),
  )
}

///|
/// Generates a simple TypeIdent (no namespace).
pub fn gen_simple_type_ident() -> @qc.Gen[@ast.TypeIdent] {
  gen_type_name().fmap(fn(name) { @ast.TypeIdent::simple(name) })
}

///|
fn gen_type_name() -> @qc.Gen[@ast.UpperIdent] {
  gen_upper_ident()
}

///|
/// Generates a Term.
pub fn gen_term() -> @qc.Gen[@ast.Term] {
  @qc.sized(fn(size) { gen_term_sized(size) })
}

///|
fn gen_term_sized(size : Int) -> @qc.Gen[@ast.Term] {
  if size <= 0 {
    @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { @ast.Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { @ast.Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { @ast.Term::NatConst(abs_int(n)) })),
      (1, @qc.pure(@ast.Term::Ident(@ast.TypeIdent::simple(@ast.UpperIdent::new(value="#"))))),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { @ast.Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { @ast.Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { @ast.Term::NatConst(abs_int(n)) })),
      (1, gen_term_sized(smaller).fmap(fn(t) { @ast.Term::Percent(t) })),
      (1, gen_expr_sized(smaller).fmap(fn(e) { @ast.Term::Paren(e) })),
      (
        1,
        @qc.liftA2(
          fn(i, params) { @ast.Term::Apply(i, params) },
          gen_simple_type_ident(),
          gen_expr_array(smaller),
        ),
      ),
    ])
  }
}

///|
/// Generates a Subexpr.
pub fn gen_subexpr() -> @qc.Gen[@ast.Subexpr] {
  @qc.sized(fn(size) { gen_subexpr_sized(size) })
}

///|
fn gen_subexpr_sized(size : Int) -> @qc.Gen[@ast.Subexpr] {
  if size <= 0 {
    gen_term().fmap(fn(t) { @ast.Subexpr::Term(t) })
  } else {
    let smaller = size / 2
    @qc.frequency([
      (5, gen_term().fmap(fn(t) { @ast.Subexpr::Term(t) })),
      (
        1,
        @qc.liftA2(
          fn(n, right) { @ast.Subexpr::AddLeft(abs_int(n), right) },
          @qc.small_int(),
          gen_subexpr_sized(smaller),
        ),
      ),
      (
        1,
        @qc.liftA2(
          fn(left, n) {
            @ast.Subexpr::AddRight(wrap_add_right_left(left), abs_int(n))
          },
          gen_subexpr_sized(smaller),
          @qc.small_int(),
        ),
      ),
    ])
  }
}

///|
/// Generates an Expr.
pub fn gen_expr() -> @qc.Gen[@ast.Expr] {
  @qc.sized(fn(size) { gen_expr_sized(size) })
}

///|
fn gen_expr_sized(size : Int) -> @qc.Gen[@ast.Expr] {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  @qc.int_range(1, 3).bind(fn(len) {
    let gen = gen_subexpr_sized(smaller)
    @qc.Gen::new(fn(s, rs) {
      let items = Array::makei(len, fn(_) { gen.run(s, rs) })
      @ast.Expr::new(items~)
    })
  })
}

///|
fn gen_expr_array(size : Int) -> @qc.Gen[Array[@ast.Expr]] {
  @qc.int_range(1, 3).bind(fn(len) {
    let gen = gen_expr_sized(size / 2)
    @qc.Gen::new(fn(s, rs) { Array::makei(len, fn(_) { gen.run(s, rs) }) })
  })
}
