///| Semantic newtype wrappers for identifiers in TL schemas

// Lowercase identifier for constructors, variables, fields: [a-z][a-z0-9_]*
pub(all) struct LowerIdent {
  value : String
} derive(Eq)

pub fn LowerIdent::new(value~ : String) -> LowerIdent {
  { value, }
}

// Uppercase identifier for type names: [A-Z][a-zA-Z0-9_]*
pub(all) struct UpperIdent {
  value : String
} derive(Eq)

pub fn UpperIdent::new(value~ : String) -> UpperIdent {
  { value, }
}

// Constructor ID (CRC32 hash)
pub(all) struct ConstructorId {
  value : UInt
} derive(Eq)

pub fn ConstructorId::new(value~ : UInt) -> ConstructorId {
  { value, }
}

// Show implementations (display just the value, not the struct)

pub impl Show for LowerIdent with output(self, logger) {
  logger.write_string(self.value)
}

pub impl Show for UpperIdent with output(self, logger) {
  logger.write_string(self.value)
}

pub impl Show for ConstructorId with output(self, logger) {
  Show::output(self.value, logger)
}

// Arbitrary implementations

///| Generates a lowercase identifier: [a-z][a-z0-9_]*
pub impl @quickcheck.Arbitrary for LowerIdent with arbitrary(size, rs) {
  let first_gen = @qc.char_range('a', 'z')
  let first = first_gen.run(size, rs)

  let len = if size > 0 { size } else { 0 }
  let actual_len_gen = @qc.int_bound(len + 1)
  let actual_len = actual_len_gen.run(size, rs)

  let rest = gen_lower_rest_chars(actual_len).run(size, rs)

  let sb = StringBuilder::new()
  sb.write_char(first)
  sb.write_string(rest)
  let name = sb.to_string()

  // Avoid TL reserved words
  let value = if name == "functions" || name == "types" {
    name + "_x"
  } else {
    name
  }
  LowerIdent::new(value~)
}

///| Helper: generates rest characters for lowercase identifiers
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

///| Generates an uppercase identifier: [A-Z][a-zA-Z0-9_]*
pub impl @quickcheck.Arbitrary for UpperIdent with arbitrary(size, rs) {
  let first_gen = @qc.char_range('A', 'Z')
  let first = first_gen.run(size, rs)

  let len = if size > 0 { size } else { 0 }
  let actual_len_gen = @qc.int_bound(len + 1)
  let actual_len = actual_len_gen.run(size, rs)

  let rest = gen_upper_rest_chars(actual_len).run(size, rs)

  let sb = StringBuilder::new()
  sb.write_char(first)
  sb.write_string(rest)
  let name = sb.to_string()

  // Avoid TL reserved words
  let value = if name == "O" ||
    name == "S" ||
    name == "New" ||
    name == "Final" ||
    name == "Empty" {
    name + "1"
  } else {
    name
  }
  UpperIdent::new(value~)
}

///| Helper: generates rest characters for uppercase identifiers
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

///| Generates a constructor ID (CRC32 hash)
pub impl @quickcheck.Arbitrary for ConstructorId with arbitrary(size, rs) {
  let value : UInt = @quickcheck.Arbitrary::arbitrary(size, rs)
  ConstructorId::new(value~)
}
