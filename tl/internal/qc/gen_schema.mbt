///|
/// Generates a Schema.
pub fn gen_schema() -> @qc.Gen[@ast.Schema] {
  @qc.sized(fn(size) { gen_schema_sized(size) })
}

///|
fn gen_schema_sized(size : Int) -> @qc.Gen[@ast.Schema] {
  @qc.liftA2(
    fn(types, functions) { { types, functions, comments: [] } },
    gen_declarations_array(size),
    gen_functions_array(size),
  )
}

///|
fn gen_declarations_array(size : Int) -> @qc.Gen[Array[@ast.Declaration]] {
  let max_len = if size > 5 { 5 } else { size + 1 }
  @qc.int_bound(max_len).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(s, rs) {
        Array::makei(len, fn(_) { gen_declaration().run(s / 2, rs) })
      })
    }
  })
}

///|
fn gen_functions_array(size : Int) -> @qc.Gen[Array[@ast.Combinator]] {
  let max_len = if size > 3 { 3 } else { size + 1 }
  @qc.int_bound(max_len).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(s, rs) {
        Array::makei(len, fn(_) { gen_combinator().run(s / 2, rs) })
      })
    }
  })
}
