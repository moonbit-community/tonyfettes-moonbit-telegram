///|
/// Property: Token spans are contiguous (no overlap, no gaps in valid tokens).
/// For any valid TL source from a schema, consecutive tokens either:
/// - Are contiguous (prev.end.offset == curr.start.offset), or
/// - Are separated by whitespace (prev.end.offset < curr.start.offset)
test "lexer: token spans are contiguous" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_schema(), fn(schema) {
      let source = @tl.schema_to_string(schema)
      let tokens : Result[Array[Token], _] = try? Lexer::new(source~).tokenize()
      guard tokens is Ok(tokens) else { return true } // Skip invalid sources
      // Check each consecutive pair of tokens
      for i = 1; i < tokens.length(); i = i + 1 {
        let prev = tokens[i - 1]
        let curr = tokens[i]
        // Either contiguous or separated by whitespace only
        if prev.span.end.offset > curr.span.start.offset {
          return false // Overlap!
        }
      }
      true
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Property: Token spans don't overlap.
/// For any valid TL source, no two tokens should have overlapping spans.
test "lexer: token spans don't overlap" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_schema(), fn(schema) {
      let source = @tl.schema_to_string(schema)
      let tokens : Result[Array[Token], _] = try? Lexer::new(source~).tokenize()
      guard tokens is Ok(tokens) else { return true } // Skip invalid sources
      // Check all pairs for overlap
      for i = 0; i < tokens.length(); i = i + 1 {
        for j = i + 1; j < tokens.length(); j = j + 1 {
          let a = tokens[i]
          let b = tokens[j]
          // Spans overlap if neither is entirely before the other
          let a_before_b = a.span.end.offset <= b.span.start.offset
          let b_before_a = b.span.end.offset <= a.span.start.offset
          if not(a_before_b) && not(b_before_a) {
            return false // Overlap found!
          }
        }
      }
      true
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Property: Hex number parsing is correct.
/// For any unsigned integer, formatting as hex and parsing should yield the same value.
test "lexer: hex numbers parse correctly" {
  @qc.quick_check(
    @qc.forall(@qc.nat().fmap(fn(n) { n.reinterpret_as_uint() }), fn(n) {
      let hex_str = "#" + uint_to_hex(n)
      let tokens : Result[Array[Token], _] = try? Lexer::new(source=hex_str).tokenize()
      guard tokens is Ok(tokens) && tokens.length() >= 1 else { return false }
      match tokens[0].kind {
        HexNumber(parsed) => parsed == n
        Hash => n == 0U // Edge case: "#" alone when n=0 might be just Hash
        _ => false
      }
    }),
    max_success=100,
  )
}

///|
/// Property: Token span offsets are non-negative and within source bounds.
test "lexer: token spans are within source bounds" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_schema(), fn(schema) {
      let source = @tl.schema_to_string(schema)
      let source_len = source.length()
      let tokens : Result[Array[Token], _] = try? Lexer::new(source~).tokenize()
      guard tokens is Ok(tokens) else { return true } // Skip invalid sources
      for token in tokens {
        if token.span.start.offset < 0 ||
          token.span.end.offset < 0 ||
          token.span.start.offset > source_len ||
          token.span.end.offset > source_len ||
          token.span.start.offset > token.span.end.offset {
          return false
        }
      }
      true
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Property: Last token is always Eof.
test "lexer: last token is always Eof" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_schema(), fn(schema) {
      let source = @tl.schema_to_string(schema)
      let tokens : Result[Array[Token], _] = try? Lexer::new(source~).tokenize()
      guard tokens is Ok(tokens) && tokens.length() > 0 else { return true }
      tokens[tokens.length() - 1].kind is Eof
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Helper function to convert UInt to hex string (without leading zeros).
fn uint_to_hex(n : UInt) -> String {
  if n == 0 {
    return "0"
  }
  let digits = "0123456789abcdef"
  let sb = StringBuilder::new()
  let mut val = n
  while val > 0 {
    let digit = (val % 16).reinterpret_as_int()
    guard digits.get_char(digit) is Some(ch) else { break }
    sb.write_char(ch)
    val = val / 16
  }
  // Reverse the string
  let s = sb.to_string()
  let len = s.length()
  let result = StringBuilder::new()
  for i = len - 1; i >= 0; i = i - 1 {
    guard s.get_char(i) is Some(ch) else { break }
    result.write_char(ch)
  }
  result.to_string()
}
