///|
/// Generates a lowercase identifier: [a-z][a-z0-9_]*
pub fn gen_lower_ident() -> @qc.Gen[String] {
  let first = @qc.char_range('a', 'z')
  let rest = @qc.sized(fn(size) {
    let len = if size > 0 { size } else { 0 }
    @qc.int_bound(len + 1).bind(fn(actual_len) {
      gen_lower_rest_chars(actual_len)
    })
  })
  @qc.liftA2(
    fn(c, s) {
      let sb = StringBuilder::new()
      sb.write_char(c)
      sb.write_string(s)
      sb.to_string()
    },
    first,
    rest,
  )
}

///|
fn gen_lower_rest_chars(len : Int) -> @qc.Gen[String] {
  if len <= 0 {
    @qc.pure("")
  } else {
    let char_gen = @qc.frequency([
      (10, @qc.char_range('a', 'z')),
      (3, @qc.char_range('0', '9')),
      (1, @qc.pure('_')),
    ])
    @qc.Gen::new(fn(size, rs) {
      let sb = StringBuilder::new()
      for i = 0; i < len; i = i + 1 {
        let c = char_gen.run(size, rs)
        sb.write_char(c)
      }
      sb.to_string()
    })
  }
}

///|
/// Generates an uppercase identifier: [A-Z][a-zA-Z0-9_]*
pub fn gen_upper_ident() -> @qc.Gen[String] {
  let first = @qc.char_range('A', 'Z')
  let rest = @qc.sized(fn(size) {
    let len = if size > 0 { size } else { 0 }
    @qc.int_bound(len + 1).bind(fn(actual_len) {
      gen_upper_rest_chars(actual_len)
    })
  })
  @qc.liftA2(
    fn(c, s) {
      let sb = StringBuilder::new()
      sb.write_char(c)
      sb.write_string(s)
      sb.to_string()
    },
    first,
    rest,
  )
}

///|
fn gen_upper_rest_chars(len : Int) -> @qc.Gen[String] {
  if len <= 0 {
    @qc.pure("")
  } else {
    let char_gen = @qc.frequency([
      (5, @qc.char_range('a', 'z')),
      (5, @qc.char_range('A', 'Z')),
      (3, @qc.char_range('0', '9')),
      (1, @qc.pure('_')),
    ])
    @qc.Gen::new(fn(size, rs) {
      let sb = StringBuilder::new()
      for i = 0; i < len; i = i + 1 {
        let c = char_gen.run(size, rs)
        sb.write_char(c)
      }
      sb.to_string()
    })
  }
}

///|
/// Generates an optional namespace (lowercase identifier).
pub fn gen_namespace() -> @qc.Gen[String?] {
  @qc.frequency([
    (3, @qc.pure(None)),
    (1, gen_lower_ident().fmap(fn(x) { Some(x) })),
  ])
}
