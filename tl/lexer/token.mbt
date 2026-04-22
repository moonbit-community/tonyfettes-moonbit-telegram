///|
/// Token kinds for TL lexer.
pub(all) enum TokenKind {
  // Identifiers
  LowerIdent(String) // user, auth, vector
  UpperIdent(String) // User, Vector, Type

  // Literals
  HexNumber(UInt) // after # in constructor ID
  Number(Int) // 123, -1

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
  TripleDash // ---

  // Keywords
  Final // Final
  New // New
  Empty // Empty
  Functions // functions (after ---)
  Types // types (after ---)

  // Comments (preserved for doc generation)
  LineComment(String) // // comment
  BlockComment(String) // /* comment */
  Eof
} derive(Debug, Eq)

///|
/// A token with its kind and source span.
pub(all) struct Token {
  kind : TokenKind
  span : @ast.Span
} derive(Debug, Eq)

///|
/// Converts a TokenKind to a string for error messages.
pub fn TokenKind::to_string(self : TokenKind) -> String {
  match self {
    LowerIdent(s) => "identifier '" + s + "'"
    UpperIdent(s) => "identifier '" + s + "'"
    HexNumber(_) => "hex number"
    Number(n) => "number " + n.to_string()
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
    Final => "'Final'"
    New => "'New'"
    Empty => "'Empty'"
    Functions => "'functions'"
    Types => "'types'"
    LineComment(_) => "line comment"
    BlockComment(_) => "block comment"
    Eof => "end of file"
  }
}
