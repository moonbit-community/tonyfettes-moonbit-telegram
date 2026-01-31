///|
/// Generates an optional Conditional.
pub fn gen_conditional() -> @qc.Gen[@ast.Conditional?] {
  @qc.frequency([
    (3, @qc.pure(None)),
    (
      1,
      @qc.liftA2(
        fn(var_name, bit_index) { Some({ var_name, bit_index }) },
        gen_lower_ident(),
        gen_optional_bit_index(),
      ),
    ),
  ])
}

///|
fn gen_optional_bit_index() -> @qc.Gen[Int?] {
  @qc.frequency([
    (1, @qc.pure(None)),
    (2, @qc.int_bound(32).fmap(fn(x) { Some(x) })),
  ])
}

///|
/// Generates a NamedArg.
pub fn gen_named_arg() -> @qc.Gen[@ast.NamedArg] {
  @qc.liftA4(
    fn(name, conditional, bang, type_) { { name, conditional, bang, type_ } },
    gen_lower_ident(),
    gen_conditional(),
    gen_bool(),
    gen_term(),
  )
}

///|
fn gen_bool() -> @qc.Gen[Bool] {
  @qc.frequency([(3, @qc.pure(false)), (1, @qc.pure(true))])
}

///|
/// Generates an OptionalArg.
pub fn gen_optional_arg() -> @qc.Gen[@ast.OptionalArg] {
  @qc.liftA3(
    fn(names, bang, type_) { { names, bang, type_ } },
    gen_names_array(),
    gen_bool(),
    gen_expr(),
  )
}

///|
fn gen_names_array() -> @qc.Gen[Array[@ast.LowerIdent]] {
  @qc.int_range(1, 4).bind(fn(len) {
    @qc.Gen::new(fn(size, rs) {
      Array::makei(len, fn(_) { gen_lower_ident().run(size, rs) })
    })
  })
}

///|
/// Generates a MultiplicityArg.
pub fn gen_multiplicity_arg() -> @qc.Gen[@ast.MultiplicityArg] {
  @qc.sized(fn(size) { gen_multiplicity_arg_sized(size) })
}

///|
fn gen_multiplicity_arg_sized(size : Int) -> @qc.Gen[@ast.MultiplicityArg] {
  @qc.liftA3(
    fn(name, count, args) { { name, count, args } },
    gen_optional_name(),
    gen_term(),
    gen_arg_array(size / 2),
  )
}

///|
fn gen_optional_name() -> @qc.Gen[@ast.LowerIdent?] {
  @qc.frequency([
    (2, @qc.pure(None)),
    (1, gen_lower_ident().fmap(fn(x) { Some(x) })),
  ])
}

///|
fn gen_arg_array(size : Int) -> @qc.Gen[Array[@ast.Arg]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      let gen = gen_arg_sized(size)
      @qc.Gen::new(fn(s, rs) { Array::makei(len, fn(_) { gen.run(s, rs) }) })
    }
  })
}

///|
/// Generates a GroupedArg.
pub fn gen_grouped_arg() -> @qc.Gen[@ast.GroupedArg] {
  @qc.liftA3(
    fn(names, bang, type_) { { names, bang, type_ } },
    gen_names_array(),
    gen_bool(),
    gen_term(),
  )
}

///|
/// Generates an AnonymousArg.
pub fn gen_anonymous_arg() -> @qc.Gen[@ast.AnonymousArg] {
  @qc.liftA2(fn(bang, type_) { { bang, type_ } }, gen_bool(), gen_term())
}

///|
/// Generates an Arg.
pub fn gen_arg() -> @qc.Gen[@ast.Arg] {
  @qc.sized(fn(size) { gen_arg_sized(size) })
}

///|
fn gen_arg_sized(size : Int) -> @qc.Gen[@ast.Arg] {
  if size <= 0 {
    // Non-recursive variants only
    @qc.frequency([
      (4, gen_named_arg().fmap(fn(x) { @ast.Arg::Named(x) })),
      (2, gen_grouped_arg().fmap(fn(x) { @ast.Arg::Grouped(x) })),
      (2, gen_anonymous_arg().fmap(fn(x) { @ast.Arg::Anonymous(x) })),
    ])
  } else {
    @qc.frequency([
      (4, gen_named_arg().fmap(fn(x) { @ast.Arg::Named(x) })),
      (
        1,
        gen_multiplicity_arg_sized(size / 2).fmap(fn(x) {
          @ast.Arg::Multiplicity(x)
        }),
      ),
      (2, gen_grouped_arg().fmap(fn(x) { @ast.Arg::Grouped(x) })),
      (2, gen_anonymous_arg().fmap(fn(x) { @ast.Arg::Anonymous(x) })),
    ])
  }
}
