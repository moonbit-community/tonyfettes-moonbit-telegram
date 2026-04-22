///|
/// Compatibility Show implementations for types migrated from derive(Show).

///|
pub impl Show for LexError with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Token with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for TokenKind with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}
