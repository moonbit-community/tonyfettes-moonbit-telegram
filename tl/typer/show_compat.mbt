///|
/// Compatibility Show implementations for types migrated from derive(Show).

///|
pub impl Show for ResolvedType with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for SymbolTable with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for TLTypeError with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}
