///|
/// Compatibility Show implementations for types migrated from derive(Show).

///|
pub impl Show for AnonymousArg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Arg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Combinator with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Conditional with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Declaration with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Expr with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for FinalDecl with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for FinalDeclData with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for GroupedArg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for MultiplicityArg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for NamedArg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for OptionalArg with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Position with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for ResultType with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Schema with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Span with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Subexpr with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for Term with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}

///|
pub impl Show for TypeIdent with output(self, logger) {
  logger.write_string(@debug.to_string(self))
}
