///|
/// Errors that can occur during TL lexing.
pub(all) suberror LexError {
  UnexpectedChar(pos~ : @ast.Position, char~ : Char)
  UnexpectedEof(pos~ : @ast.Position)
  InvalidHexId(pos~ : @ast.Position, value~ : String)
  InvalidNumber(pos~ : @ast.Position, value~ : String)
} derive(Show, Eq)

///|
/// The lexer state for tokenizing TL source code.
pub(all) struct Lexer {
  source : String
  mut pos : Int // Current byte position
  mut line : Int // Current line (1-based)
  mut column : Int // Current column (1-based)
}

///|
/// Creates a new lexer for the given source string.
pub fn Lexer::new(source~ : String) -> Lexer {
  { source, pos: 0, line: 1, column: 1 }
}

///|
/// Returns the current position in the source.
fn Lexer::current_position(self : Lexer) -> @ast.Position {
  @ast.Position::new(line=self.line, column=self.column, offset=self.pos)
}

///|
/// Returns the current character without advancing.
fn Lexer::peek(self : Lexer) -> Char? {
  if self.pos >= self.source.length() {
    None
  } else {
    self.source.get_char(self.pos)
  }
}

///|
/// Returns the character at the given offset from current position without advancing.
fn Lexer::peek_at(self : Lexer, offset : Int) -> Char? {
  let idx = self.pos + offset
  if idx >= self.source.length() {
    None
  } else {
    self.source.get_char(idx)
  }
}

///|
/// Returns the current character and advances the position.
fn Lexer::advance(self : Lexer) -> Char? {
  guard self.peek() is Some(ch) else { return None }
  self.pos += 1
  if ch == '\n' {
    self.line += 1
    self.column = 1
  } else {
    self.column += 1
  }
  Some(ch)
}

///|
/// Skips whitespace characters (spaces, tabs, newlines, carriage returns).
fn Lexer::skip_whitespace(self : Lexer) -> Unit {
  while self.peek() is Some(' ' | '\t' | '\n' | '\r') {
    let _ = self.advance()

  }
}

///|
/// Creates a span from the start position to the current position.
fn Lexer::make_span(self : Lexer, start : @ast.Position) -> @ast.Span {
  @ast.Span::new(start~, end=self.current_position())
}

///|
/// Checks if a character is a valid identifier continuation.
fn is_ident_continue(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') ||
  (ch >= 'A' && ch <= 'Z') ||
  (ch >= '0' && ch <= '9') ||
  ch == '_'
}

///|
/// Checks if a character is a decimal digit.
fn is_digit(ch : Char) -> Bool {
  ch >= '0' && ch <= '9'
}

///|
/// Checks if a character is a hexadecimal digit.
fn is_hex_digit(ch : Char) -> Bool {
  (ch >= '0' && ch <= '9') ||
  (ch >= 'a' && ch <= 'f') ||
  (ch >= 'A' && ch <= 'F')
}

///|
/// Scans an identifier (lowercase or uppercase).
fn Lexer::scan_identifier(self : Lexer) -> Token {
  let start = self.current_position()
  let is_upper = self.peek() is Some('A'..='Z')
  let buf = StringBuilder::new()
  while self.peek() is Some(ch) && is_ident_continue(ch) {
    buf.write_char(ch)
    let _ = self.advance()

  }
  let ident = buf.to_string()
  // Check for keywords
  let kind = if is_upper {
    match ident {
      "Final" => TokenKind::Final
      "New" => TokenKind::New
      "Empty" => TokenKind::Empty
      _ => TokenKind::UpperIdent(ident)
    }
  } else {
    match ident {
      "functions" => TokenKind::Functions
      "types" => TokenKind::Types
      _ => TokenKind::LowerIdent(ident)
    }
  }
  { kind, span: self.make_span(start) }
}

///|
/// Scans a decimal number.
fn Lexer::scan_number(self : Lexer) -> Token raise LexError {
  let start = self.current_position()
  let buf = StringBuilder::new()
  // Handle optional leading minus
  if self.peek() is Some('-') {
    buf.write_char('-')
    let _ = self.advance()

  }
  while self.peek() is Some(ch) && is_digit(ch) {
    buf.write_char(ch)
    let _ = self.advance()

  }
  let num_str = buf.to_string()
  let result : Result[Int, _] = try? @strconv.parse_int(num_str)
  guard result is Ok(n) else {
    raise LexError::InvalidNumber(pos=start, value=num_str)
  }
  { kind: TokenKind::Number(n), span: self.make_span(start) }
}

///|
/// Scans a hexadecimal number (after # has been consumed).
fn Lexer::scan_hex_number(
  self : Lexer,
  start : @ast.Position,
) -> Token raise LexError {
  let buf = StringBuilder::new()
  while self.peek() is Some(ch) && is_hex_digit(ch) {
    buf.write_char(ch)
    let _ = self.advance()

  }
  let hex_str = buf.to_string()
  if hex_str.is_empty() {
    // Just # with no hex digits - return Hash token
    return { kind: TokenKind::Hash, span: self.make_span(start) }
  }
  let result : Result[UInt, _] = try? @strconv.parse_uint(hex_str, base=16)
  guard result is Ok(n) else {
    raise LexError::InvalidHexId(pos=start, value=hex_str)
  }
  { kind: TokenKind::HexNumber(n), span: self.make_span(start) }
}

///|
/// Scans a line comment (after // has been consumed).
fn Lexer::scan_line_comment(self : Lexer, start : @ast.Position) -> Token {
  let buf = StringBuilder::new()
  while self.peek() is Some(ch) && ch != '\n' {
    buf.write_char(ch)
    let _ = self.advance()

  }
  { kind: TokenKind::LineComment(buf.to_string()), span: self.make_span(start) }
}

///|
/// Scans a block comment (after /* has been consumed).
fn Lexer::scan_block_comment(
  self : Lexer,
  start : @ast.Position,
) -> Token raise LexError {
  let buf = StringBuilder::new()
  while true {
    guard self.peek() is Some(ch) else {
      raise LexError::UnexpectedEof(pos=self.current_position())
    }
    if ch == '*' && self.peek_at(1) is Some('/') {
      let _ = self.advance() // consume *
      let _ = self.advance() // consume /
      break
    }
    buf.write_char(ch)
    let _ = self.advance()

  }
  {
    kind: TokenKind::BlockComment(buf.to_string()),
    span: self.make_span(start),
  }
}

///|
/// Scans the next token from the source.
pub fn Lexer::next_token(self : Lexer) -> Token raise LexError {
  self.skip_whitespace()
  let start = self.current_position()
  guard self.peek() is Some(ch) else {
    return { kind: TokenKind::Eof, span: self.make_span(start) }
  }
  match ch {
    'a'..='z' | '_' => self.scan_identifier()
    'A'..='Z' => self.scan_identifier()
    '0'..='9' => self.scan_number()
    '#' => {
      let _ = self.advance() // consume #
      // Check if followed by hex digits
      if self.peek() is Some(next_ch) && is_hex_digit(next_ch) {
        self.scan_hex_number(start)
      } else {
        { kind: TokenKind::Hash, span: self.make_span(start) }
      }
    }
    ':' => {
      let _ = self.advance()
      { kind: TokenKind::Colon, span: self.make_span(start) }
    }
    ';' => {
      let _ = self.advance()
      { kind: TokenKind::Semicolon, span: self.make_span(start) }
    }
    '=' => {
      let _ = self.advance()
      { kind: TokenKind::Equals, span: self.make_span(start) }
    }
    '?' => {
      let _ = self.advance()
      { kind: TokenKind::Question, span: self.make_span(start) }
    }
    '.' => {
      let _ = self.advance()
      { kind: TokenKind::Dot, span: self.make_span(start) }
    }
    '(' => {
      let _ = self.advance()
      { kind: TokenKind::LParen, span: self.make_span(start) }
    }
    ')' => {
      let _ = self.advance()
      { kind: TokenKind::RParen, span: self.make_span(start) }
    }
    '[' => {
      let _ = self.advance()
      { kind: TokenKind::LBracket, span: self.make_span(start) }
    }
    ']' => {
      let _ = self.advance()
      { kind: TokenKind::RBracket, span: self.make_span(start) }
    }
    '{' => {
      let _ = self.advance()
      { kind: TokenKind::LBrace, span: self.make_span(start) }
    }
    '}' => {
      let _ = self.advance()
      { kind: TokenKind::RBrace, span: self.make_span(start) }
    }
    '<' => {
      let _ = self.advance()
      { kind: TokenKind::LAngle, span: self.make_span(start) }
    }
    '>' => {
      let _ = self.advance()
      { kind: TokenKind::RAngle, span: self.make_span(start) }
    }
    '%' => {
      let _ = self.advance()
      { kind: TokenKind::Percent, span: self.make_span(start) }
    }
    '!' => {
      let _ = self.advance()
      { kind: TokenKind::Bang, span: self.make_span(start) }
    }
    '*' => {
      let _ = self.advance()
      { kind: TokenKind::Star, span: self.make_span(start) }
    }
    '+' => {
      let _ = self.advance()
      { kind: TokenKind::Plus, span: self.make_span(start) }
    }
    ',' => {
      let _ = self.advance()
      { kind: TokenKind::Comma, span: self.make_span(start) }
    }
    '-' =>
      // Check for ---
      if self.peek_at(1) is Some('-') && self.peek_at(2) is Some('-') {
        let _ = self.advance() // consume first -
        let _ = self.advance() // consume second -
        let _ = self.advance() // consume third -
        { kind: TokenKind::TripleDash, span: self.make_span(start) }
      } else if self.peek_at(1) is Some('0'..='9') {
        // Negative number
        self.scan_number()
      } else {
        raise LexError::UnexpectedChar(pos=start, char=ch)
      }
    '/' =>
      // Check for // or /*
      if self.peek_at(1) is Some('/') {
        let _ = self.advance() // consume first /
        let _ = self.advance() // consume second /
        self.scan_line_comment(start)
      } else if self.peek_at(1) is Some('*') {
        let _ = self.advance() // consume /
        let _ = self.advance() // consume *
        self.scan_block_comment(start)
      } else {
        raise LexError::UnexpectedChar(pos=start, char=ch)
      }
    _ => raise LexError::UnexpectedChar(pos=start, char=ch)
  }
}

///|
/// Tokenizes the entire source and returns all tokens.
pub fn Lexer::tokenize(self : Lexer) -> Array[Token] raise LexError {
  let tokens : Array[Token] = []
  while true {
    let token = self.next_token()
    tokens.push(token)
    if token.kind is Eof {
      break
    }
  }
  tokens
}
