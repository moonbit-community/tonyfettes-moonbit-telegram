///|
/// Conditional field specifier (e.g., flags.N? or flags?)
pub(all) struct Conditional {
  var_name : LowerIdent // "flags", "flags2"
  bit_index : Int? // None for flags?, Some(N) for flags.N?
} derive(Show, Eq)

///|
/// Named argument: name:Type or name:flags.N?Type
pub(all) struct NamedArg {
  name : LowerIdent
  conditional : Conditional?
  bang : Bool // ! prefix
  type_ : Term
} derive(Show, Eq)

///|
/// Optional/generic param: {t:Type} or {n:#}
pub(all) struct OptionalArg {
  names : Array[LowerIdent] // Can have multiple: {x y : Type}
  bang : Bool
  type_ : Expr
} derive(Show, Eq)

///|
/// Multiplicity: 4*[int] or n*[type]
pub(all) struct MultiplicityArg {
  name : LowerIdent? // Optional name before :
  count : Term // nat-term
  args : Array[Arg] // Nested args in [ ]
} derive(Show, Eq)

///|
/// Grouped args: (x y : Type)
pub(all) struct GroupedArg {
  names : Array[LowerIdent]
  bang : Bool
  type_ : Term
} derive(Show, Eq)

///|
/// Anonymous type argument: !Type or Type
pub(all) struct AnonymousArg {
  bang : Bool
  type_ : Term
} derive(Show, Eq)

///|
/// Argument variants in a combinator
pub(all) enum Arg {
  // Named arg: name:Type or name:flags.N?Type
  Named(NamedArg)
  // Multiplicity: 4*[int] or n*[type]
  Multiplicity(MultiplicityArg)
  // Grouped args: (x y : Type)
  Grouped(GroupedArg)
  // Anonymous type: !Type or Type
  Anonymous(AnonymousArg)
} derive(Show, Eq)

///|
/// Result type of a combinator
pub(all) struct ResultType {
  type_ident : TypeIdent
  params : Array[Subexpr] // Subexpressions
} derive(Show, Eq)

///|
/// A constructor or function
pub(all) struct Combinator {
  ns : LowerIdent? // namespace
  name : LowerIdent // "_" for anonymous
  id : ConstructorId? // Hex ID after #
  opt_args : Array[OptionalArg]
  args : Array[Arg]
  result : ResultType
  span : Span
} derive(Show, Eq)

///|
/// Final declaration (includes span for error reporting)
pub(all) struct FinalDeclData {
  type_ident : TypeIdent
  span : Span
} derive(Show, Eq)

///|
/// Final declarations
pub(all) enum FinalDecl {
  New(FinalDeclData)
  Final(FinalDeclData)
  Empty(FinalDeclData)
} derive(Show, Eq)

///|
/// Top-level declaration
pub(all) enum Declaration {
  Combinator(Combinator)
  Final(FinalDecl)
} derive(Show, Eq)
