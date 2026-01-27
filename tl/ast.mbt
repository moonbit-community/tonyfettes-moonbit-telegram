///|
// Placeholder types until expr.mbt is merged
pub(all) struct TypeIdent {
  ns : String? // namespace
  name : String
} derive(Show, Eq)

///|
pub(all) enum TypeExpr {
  Ident(TypeIdent)
  Bang(TypeExpr)
  Percent(TypeExpr)
  Apply(TypeIdent, Array[TypeExpr])
  Var(String)
  Nat
} derive(Show, Eq)

///|
pub(all) enum NatExpr {
  Const(Int)
  Var(String)
  Add(NatExpr, NatExpr)
} derive(Show, Eq)

///|
pub(all) enum Expr {
  Type(TypeExpr)
  Nat(NatExpr)
} derive(Show, Eq)

///|
/// Conditional field specifier (e.g., flags.N? or flags?)
pub(all) struct Conditional {
  var_name : String // "flags", "flags2"
  bit_index : Int? // None for flags?, Some(N) for flags.N?
} derive(Show, Eq)

///|
/// Named argument: name:Type or name:flags.N?Type
pub(all) struct NamedArg {
  name : String
  conditional : Conditional?
  bang : Bool // ! prefix
  type_ : TypeExpr
} derive(Show, Eq)

///|
/// Optional/generic param: {t:Type} or {n:#}
pub(all) struct OptionalArg {
  names : Array[String] // Can have multiple: {x y : Type}
  bang : Bool
  type_ : TypeExpr
} derive(Show, Eq)

///|
/// Multiplicity: 4*[int] or n*[type]
pub(all) struct MultiplicityArg {
  name : String? // Optional name before :
  count : NatExpr // 4 or n (variable)
  args : Array[Arg] // Nested args in [ ]
} derive(Show, Eq)

///|
/// Grouped args: (x y : Type)
pub(all) struct GroupedArg {
  names : Array[String]
  bang : Bool
  type_ : TypeExpr
} derive(Show, Eq)

///|
/// Argument variants in a combinator
pub(all) enum Arg {
  // Named arg: name:Type or name:flags.N?Type
  Named(NamedArg)
  // Optional/generic param: {t:Type} or {n:#}
  Optional(OptionalArg)
  // Multiplicity: 4*[int] or n*[type]
  Multiplicity(MultiplicityArg)
  // Grouped args: (x y : Type)
  Grouped(GroupedArg)
  // Anonymous type: !Type or Type
  Anonymous(TypeExpr)
} derive(Show, Eq)

///|
/// Result type of a combinator
pub(all) struct ResultType {
  type_ident : TypeIdent
  params : Array[Expr] // Type or nat params
} derive(Show, Eq)

///|
/// A constructor or function
pub(all) struct Combinator {
  ns : String? // namespace
  name : String // "_" for anonymous
  id : UInt? // Hex ID after #
  opt_args : Array[OptionalArg]
  args : Array[Arg]
  result : ResultType
  span : Span
} derive(Show, Eq)

///|
/// Final declarations
pub(all) enum FinalDecl {
  New(TypeIdent)
  Final(TypeIdent)
  Empty(TypeIdent)
} derive(Show, Eq)

///|
/// Top-level declaration
pub(all) enum Declaration {
  Combinator(Combinator)
  Final(FinalDecl)
} derive(Show, Eq)
