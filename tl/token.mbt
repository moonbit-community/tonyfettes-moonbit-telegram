///|
/// Position in the source text.
pub(all) struct Position {
  line : Int
  column : Int
  offset : Int
} derive(Show, Eq)

///|
/// Span representing a range in the source text.
pub(all) struct Span {
  start : Position
  end : Position
} derive(Show, Eq)

///|
/// Token kinds for the TL lexer.
pub(all) enum TokenKind {
  // Identifiers
  LowerIdent(String) // user, auth, first_name
  UpperIdent(String) // User, Vector, Type

  // Literals
  HexNumber(UInt) // hex number after # in constructor ID (e.g., d23c81a3)
  Number(Int) // decimal number (e.g., 123)

  // Punctuation
  Hash // #
  Colon // :
  Semicolon // ;
  Equals // =
  Question // ?
  Dot // .
  LParen // (
  RParen // )
  LBracket // [
  RBracket // ]
  LBrace // {
  RBrace // }
  LAngle // <
  RAngle // >
  Percent // %
  Bang // !
  Star // *
  Plus // +
  Comma // ,
  Underscore // _

  // Section separators
  TripleDash // ---

  // Keywords (after ---)
  Functions // functions
  Types // types

  // Finalization keywords
  Final // Final
  New // New
  Empty // Empty

  // Comments (preserved for doc generation)
  LineComment(String) // // comment
  BlockComment(String) // /* comment */

  // End of file
  Eof
} derive(Show, Eq)

///|
/// A token with its kind and source span.
pub(all) struct Token {
  kind : TokenKind
  span : Span
} derive(Show, Eq)

///|
/// Returns a human-readable string representation of the token kind for error messages.
pub fn TokenKind::to_string(self : TokenKind) -> String {
  match self {
    LowerIdent(s) => "identifier '\{s}'"
    UpperIdent(s) => "identifier '\{s}'"
    HexNumber(n) => "hex number '\{n}'"
    Number(n) => "number '\{n}'"
    Hash => "'#'"
    Colon => "':'"
    Semicolon => "';'"
    Equals => "'='"
    Question => "'?'"
    Dot => "'.'"
    LParen => "'('"
    RParen => "')'"
    LBracket => "'['"
    RBracket => "']'"
    LBrace => "'{'"
    RBrace => "'}'"
    LAngle => "'<'"
    RAngle => "'>'"
    Percent => "'%'"
    Bang => "'!'"
    Star => "'*'"
    Plus => "'+'"
    Comma => "','"
    Underscore => "'_'"
    TripleDash => "'---'"
    Functions => "'functions'"
    Types => "'types'"
    Final => "'Final'"
    New => "'New'"
    Empty => "'Empty'"
    LineComment(s) => "line comment '\{s}'"
    BlockComment(s) => "block comment '\{s}'"
    Eof => "end of file"
  }
}
