///|
/// Generates a simple TypeExpr without variable references.
/// Use this for round-trip testing where we don't track context.
pub fn gen_simple_type_expr() -> @qc.Gen[@ast.TypeExpr] {
  @qc.sized(fn(size) { gen_simple_type_expr_sized(size) })
}

///|
fn gen_simple_type_expr_sized(size : Int) -> @qc.Gen[@ast.TypeExpr] {
  if size <= 0 {
    // Base cases: Ident, Nat only (no Var)
    @qc.frequency([
      (5, gen_type_ident().fmap(fn(i) { @ast.TypeExpr::Ident(i) })),
      (1, @qc.pure(@ast.TypeExpr::Nat)),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (5, gen_type_ident().fmap(fn(i) { @ast.TypeExpr::Ident(i) })),
      (1, @qc.pure(@ast.TypeExpr::Nat)),
      (
        1,
        gen_simple_type_expr_sized(smaller).fmap(fn(x) {
          @ast.TypeExpr::Bang(x)
        }),
      ),
      (
        1,
        gen_simple_type_expr_sized(smaller).fmap(fn(x) {
          @ast.TypeExpr::Percent(x)
        }),
      ),
    ])
  }
}

///|
/// Generates a simple NamedArg without conditional references.
fn gen_simple_named_arg() -> @qc.Gen[@ast.NamedArg] {
  @qc.liftA3(
    fn(name, bang, type_) { { name, conditional: None, bang, type_ } },
    gen_lower_ident(),
    gen_bool(),
    gen_simple_type_expr(),
  )
}

///|
/// Generates a simple Arg (only Named, Grouped, Anonymous - no Optional or Multiplicity).
pub fn gen_simple_arg() -> @qc.Gen[@ast.Arg] {
  @qc.frequency([
    (4, gen_simple_named_arg().fmap(fn(x) { @ast.Arg::Named(x) })),
    (2, gen_simple_grouped_arg().fmap(fn(x) { @ast.Arg::Grouped(x) })),
    (2, gen_simple_type_expr().fmap(fn(x) { @ast.Arg::Anonymous(x) })),
  ])
}

///|
fn gen_simple_grouped_arg() -> @qc.Gen[@ast.GroupedArg] {
  @qc.liftA3(
    fn(names, bang, type_) { { names, bang, type_ } },
    gen_names_array(),
    gen_bool(),
    gen_simple_type_expr(),
  )
}

///|
fn gen_simple_args_array() -> @qc.Gen[Array[@ast.Arg]] {
  @qc.int_bound(4).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) { gen_simple_arg().run(size, rs) })
      })
    }
  })
}

///|
/// Generates a simple Expr without variable references.
pub fn gen_simple_expr() -> @qc.Gen[@ast.Expr] {
  @qc.frequency([
    (3, gen_simple_type_expr().fmap(fn(t) { @ast.Expr::Type(t) })),
    (1, gen_simple_nat_expr().fmap(fn(n) { @ast.Expr::Nat(n) })),
  ])
}

///|
/// Generates a simple NatExpr without variable references.
pub fn gen_simple_nat_expr() -> @qc.Gen[@ast.NatExpr] {
  @qc.sized(fn(size) { gen_simple_nat_expr_sized(size) })
}

///|
fn gen_simple_nat_expr_sized(size : Int) -> @qc.Gen[@ast.NatExpr] {
  if size <= 0 {
    // Base cases only - no Var
    @qc.frequency([
      (4, @qc.small_int().fmap(fn(n) { @ast.NatExpr::Const(n.abs()) })),
      (1, @qc.pure(@ast.NatExpr::Zero)),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (4, @qc.small_int().fmap(fn(n) { @ast.NatExpr::Const(n.abs()) })),
      (1, @qc.pure(@ast.NatExpr::Zero)),
      (
        1,
        @qc.liftA2(
          fn(l, r) { @ast.NatExpr::Add(l, r) },
          gen_simple_nat_expr_sized(smaller),
          gen_simple_nat_expr_sized(smaller),
        ),
      ),
      (
        1,
        gen_simple_nat_expr_sized(smaller).fmap(fn(x) { @ast.NatExpr::Succ(x) }),
      ),
    ])
  }
}

///|
fn gen_simple_expr_array() -> @qc.Gen[Array[@ast.Expr]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) { gen_simple_expr().run(size, rs) })
      })
    }
  })
}

///|
/// Generates a simple ResultType.
fn gen_simple_result_type() -> @qc.Gen[@ast.ResultType] {
  @qc.liftA2(
    fn(type_ident, params) { { type_ident, params } },
    gen_type_ident(),
    gen_simple_expr_array(),
  )
}

///|
/// Generates a simple Combinator without opt_args or complex features.
pub fn gen_simple_combinator() -> @qc.Gen[@ast.Combinator] {
  @qc.liftA4(
    fn(ns, name, args, result) {
      {
        ns,
        name,
        id: None, // Let CRC32 be computed
        opt_args: [],
        args,
        result,
        span: dummy_span(),
      }
    },
    gen_namespace(),
    gen_lower_ident(),
    gen_simple_args_array(),
    gen_simple_result_type(),
  )
}

///|
/// Generates a simple Declaration.
pub fn gen_simple_declaration() -> @qc.Gen[@ast.Declaration] {
  @qc.frequency([
    (5, gen_simple_combinator().fmap(fn(x) { @ast.Declaration::Combinator(x) })),
    (1, gen_final_decl().fmap(fn(x) { @ast.Declaration::Final(x) })),
  ])
}

///|
fn gen_simple_declarations_array(
  size : Int,
) -> @qc.Gen[Array[@ast.Declaration]] {
  let max_len = if size > 5 { 5 } else { size + 1 }
  @qc.int_bound(max_len).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(s, rs) {
        Array::makei(len, fn(_) { gen_simple_declaration().run(s / 2, rs) })
      })
    }
  })
}

///|
fn gen_simple_functions_array(size : Int) -> @qc.Gen[Array[@ast.Combinator]] {
  let max_len = if size > 3 { 3 } else { size + 1 }
  @qc.int_bound(max_len).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(s, rs) {
        Array::makei(len, fn(_) { gen_simple_combinator().run(s / 2, rs) })
      })
    }
  })
}

///|
/// Generates a simple Schema without complex features like opt_args, conditionals, or type variables.
/// Suitable for round-trip testing.
pub fn gen_simple_schema() -> @qc.Gen[@ast.Schema] {
  @qc.sized(fn(size) {
    @qc.liftA2(
      fn(types, functions) { { types, functions, comments: [] } },
      gen_simple_declarations_array(size),
      gen_simple_functions_array(size),
    )
  })
}
