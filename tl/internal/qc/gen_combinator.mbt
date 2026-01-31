///|
/// Generates a ResultType.
pub fn gen_result_type() -> @qc.Gen[@ast.ResultType] {
  @qc.liftA2(
    fn(type_ident, params) { { type_ident, params } },
    gen_type_ident(),
    gen_subexpr_array(),
  )
}

///|
fn gen_subexpr_array() -> @qc.Gen[Array[@ast.Subexpr]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) { gen_subexpr().run(size, rs) })
      })
    }
  })
}

///|
fn gen_optional_args_array() -> @qc.Gen[Array[@ast.OptionalArg]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) { gen_optional_arg().run(size, rs) })
      })
    }
  })
}

///|
fn gen_args_array() -> @qc.Gen[Array[@ast.Arg]] {
  @qc.sized(fn(size) {
    @qc.int_bound(4).bind(fn(len) {
      if len == 0 {
        @qc.pure([])
      } else {
        let gen = gen_arg_sized(size / 2)
        @qc.Gen::new(fn(s, rs) { Array::makei(len, fn(_) { gen.run(s, rs) }) })
      }
    })
  })
}

///|
fn gen_optional_uint() -> @qc.Gen[@ast.ConstructorId?] {
  @qc.frequency([
    (2, @qc.pure(None)),
    (1, @qc.nat().fmap(fn(n) { Some(@ast.ConstructorId::new(value=n.reinterpret_as_uint())) })),
  ])
}

///|
/// Generates a Combinator.
pub fn gen_combinator() -> @qc.Gen[@ast.Combinator] {
  @qc.liftA6(
    fn(ns, name, id, opt_args, args, result) {
      { ns, name, id, opt_args, args, result, span: dummy_span() }
    },
    gen_namespace(),
    gen_lower_ident(),
    gen_optional_uint(),
    gen_optional_args_array(),
    gen_args_array(),
    gen_result_type(),
  )
}

///|
/// Creates a dummy span (all zeros) for generated AST nodes.
pub fn dummy_span() -> @ast.Span {
  let pos = @ast.Position::new(line=0, column=0, offset=0)
  @ast.Span::new(start=pos, end=pos)
}

///|
/// Generates a FinalDecl.
pub fn gen_final_decl() -> @qc.Gen[@ast.FinalDecl] {
  let data_gen : @qc.Gen[@ast.FinalDeclData] = gen_type_ident().fmap(fn(
    type_ident,
  ) {
    { type_ident, span: dummy_span() }
  })
  @qc.frequency([
    (1, data_gen.fmap(fn(x) { @ast.FinalDecl::New(x) })),
    (1, data_gen.fmap(fn(x) { @ast.FinalDecl::Final(x) })),
    (1, data_gen.fmap(fn(x) { @ast.FinalDecl::Empty(x) })),
  ])
}

///|
/// Generates a Declaration.
pub fn gen_declaration() -> @qc.Gen[@ast.Declaration] {
  @qc.frequency([
    (5, gen_combinator().fmap(fn(x) { @ast.Declaration::Combinator(x) })),
    (1, gen_final_decl().fmap(fn(x) { @ast.Declaration::Final(x) })),
  ])
}
