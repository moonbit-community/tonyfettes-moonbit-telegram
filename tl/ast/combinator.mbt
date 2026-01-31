///|
/// Conditional field specifier (e.g., flags.N? or flags?)
pub(all) struct Conditional {
  var_name : LowerIdent // "flags", "flags2"
  bit_index : Int? // None for flags?, Some(N) for flags.N?
} derive(Show)

///|
pub impl Eq for Conditional with equal(self, other) {
  self.var_name == other.var_name && self.bit_index == other.bit_index
}

///|
/// Named argument: name:Type or name:flags.N?Type
pub(all) struct NamedArg {
  name : LowerIdent
  conditional : Conditional?
  bang : Bool // ! prefix
  type_ : Term
} derive(Show)

///|
pub impl Eq for NamedArg with equal(self, other) {
  self.name == other.name &&
  self.conditional == other.conditional &&
  self.bang == other.bang &&
  self.type_ == other.type_
}

///|
/// Optional/generic param: {t:Type} or {n:#}
pub(all) struct OptionalArg {
  names : Array[LowerIdent] // Can have multiple: {x y : Type}
  bang : Bool
  type_ : Expr
} derive(Show)

///|
pub impl Eq for OptionalArg with equal(self, other) {
  self.names == other.names &&
  self.bang == other.bang &&
  self.type_ == other.type_
}

///|
/// Multiplicity: 4*[int] or n*[type]
pub(all) struct MultiplicityArg {
  name : LowerIdent? // Optional name before :
  count : Term // nat-term
  args : Array[Arg] // Nested args in [ ]
} derive(Show)

///|
pub impl Eq for MultiplicityArg with equal(self, other) {
  self.name == other.name &&
  self.count == other.count &&
  self.args == other.args
}

///|
/// Grouped args: (x y : Type)
pub(all) struct GroupedArg {
  names : Array[LowerIdent]
  bang : Bool
  type_ : Term
} derive(Show)

///|
pub impl Eq for GroupedArg with equal(self, other) {
  self.names == other.names &&
  self.bang == other.bang &&
  self.type_ == other.type_
}

///|
/// Anonymous type argument: !Type or Type
pub(all) struct AnonymousArg {
  bang : Bool
  type_ : Term
} derive(Show)

///|
pub impl Eq for AnonymousArg with equal(self, other) {
  self.bang == other.bang && self.type_ == other.type_
}

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
} derive(Show)

///|
pub impl Eq for Arg with equal(self, other) {
  match (self, other) {
    (Named(n1), Named(n2)) => n1 == n2
    (Multiplicity(m1), Multiplicity(m2)) => m1 == m2
    (Grouped(g1), Grouped(g2)) => g1 == g2
    (Anonymous(a1), Anonymous(a2)) => a1 == a2
    _ => false
  }
}

///|
/// Result type of a combinator
pub(all) struct ResultType {
  type_ident : TypeIdent
  params : Array[Subexpr] // Subexpressions
} derive(Show)

///|
pub impl Eq for ResultType with equal(self, other) {
  self.type_ident == other.type_ident &&
  self.params == other.params
}

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
} derive(Show)

///|
/// Custom equality that ignores span field for property-based testing.
pub impl Eq for Combinator with equal(self, other) {
  self.ns == other.ns &&
  self.name == other.name &&
  self.id == other.id &&
  self.opt_args == other.opt_args &&
  self.args == other.args &&
  self.result == other.result
  // Intentionally ignoring span field
}

///|
/// Final declaration (includes span for error reporting)
pub(all) struct FinalDeclData {
  type_ident : TypeIdent
  span : Span
} derive(Show)

///|
/// Custom equality that ignores span field for property-based testing.
pub impl Eq for FinalDeclData with equal(self, other) {
  self.type_ident == other.type_ident
  // Intentionally ignoring span field
}

///|
/// Final declarations
pub(all) enum FinalDecl {
  New(FinalDeclData)
  Final(FinalDeclData)
  Empty(FinalDeclData)
} derive(Show)

///|
pub impl Eq for FinalDecl with equal(self, other) {
  match (self, other) {
    (New(d1), New(d2)) => d1 == d2
    (Final(d1), Final(d2)) => d1 == d2
    (Empty(d1), Empty(d2)) => d1 == d2
    _ => false
  }
}

///|
/// Top-level declaration
pub(all) enum Declaration {
  Combinator(Combinator)
  Final(FinalDecl)
} derive(Show)

///|
pub impl Eq for Declaration with equal(self, other) {
  match (self, other) {
    (Combinator(c1), Combinator(c2)) => c1 == c2
    (Final(f1), Final(f2)) => f1 == f2
    _ => false
  }
}
