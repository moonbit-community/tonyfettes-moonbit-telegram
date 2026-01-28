///|
/// Errors that can occur during TL type checking.
pub(all) suberror TLTypeError {
  UndefinedType(pos~ : @ast.Span, name~ : String)
  DuplicateConstructorId(
    pos~ : @ast.Span,
    id~ : UInt,
    first~ : String,
    second~ : String
  )
  DuplicateConstructorName(pos~ : @ast.Span, name~ : String)
  UndefinedFlagsField(pos~ : @ast.Span, conditional~ : String, ctor~ : String)
  UnboundTypeVariable(pos~ : @ast.Span, variable~ : String)
  UnboundNatVariable(pos~ : @ast.Span, variable~ : String)
  UnusedOptionalParameter(pos~ : @ast.Span, variable~ : String)
  FinalTypeViolation(pos~ : @ast.Span, type_name~ : String)
  NewTypeViolation(pos~ : @ast.Span, type_name~ : String)
  EmptyTypeViolation(pos~ : @ast.Span, type_name~ : String)
} derive(Show, Eq)
