///|
/// Compatibility Show implementations for types migrated from derive(Show).

///|
pub impl Show for ParseError with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}
