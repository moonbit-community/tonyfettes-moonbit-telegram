///|
/// Placeholder until position.mbt is merged
pub(all) struct Position {
  line : Int
  column : Int
  offset : Int
} derive(Show, Eq)

///|
pub(all) suberror TLParseError {
  UnexpectedChar(pos~ : Position, char~ : Char)
  UnexpectedToken(pos~ : Position, expected~ : String, found~ : String)
  UnexpectedEof(pos~ : Position)
  InvalidHexId(pos~ : Position, value~ : String)
  InvalidNumber(pos~ : Position, value~ : String)
}

///|
pub impl Show for TLParseError with output(
  self : TLParseError,
  logger : &Logger,
) -> Unit {
  match self {
    TLParseError::UnexpectedChar(pos~, char~) =>
      logger.write_string("UnexpectedChar(pos=\{pos}, char=\{char})")
    TLParseError::UnexpectedToken(pos~, expected~, found~) =>
      logger.write_string(
        "UnexpectedToken(pos=\{pos}, expected=\{expected}, found=\{found})",
      )
    TLParseError::UnexpectedEof(pos~) =>
      logger.write_string("UnexpectedEof(pos=\{pos})")
    TLParseError::InvalidHexId(pos~, value~) =>
      logger.write_string("InvalidHexId(pos=\{pos}, value=\{value})")
    TLParseError::InvalidNumber(pos~, value~) =>
      logger.write_string("InvalidNumber(pos=\{pos}, value=\{value})")
  }
}
