///|
/// A resolved type with all its constructors.
pub(all) struct ResolvedType {
  name : @ast.TypeIdent
  constructors : Array[@ast.Combinator]
  is_final : Bool
  is_empty : Bool
} derive(Show, Eq)

///|
/// Creates a new resolved type.
pub fn ResolvedType::new(
  name~ : @ast.TypeIdent,
  constructors? : Array[@ast.Combinator],
  is_final? : Bool,
  is_empty? : Bool,
) -> ResolvedType {
  {
    name,
    constructors: constructors.unwrap_or([]),
    is_final: is_final.unwrap_or(false),
    is_empty: is_empty.unwrap_or(false),
  }
}

///|
/// Symbol table for a checked schema.
pub(all) struct SymbolTable {
  /// Map from type name (with namespace) to resolved type
  types : Map[String, ResolvedType]
  /// Map from constructor ID to constructor (for ID uniqueness)
  ids : Map[UInt, @ast.Combinator]
  /// Map from constructor name (with namespace) to constructor
  constructors : Map[String, @ast.Combinator]
  /// Map from function name (with namespace) to function
  functions : Map[String, @ast.Combinator]
  /// Built-in types that don't need declarations
  builtins : Map[String, Unit]
} derive(Show, Eq)

///|
/// Creates a new empty symbol table with built-in types.
pub fn SymbolTable::new() -> SymbolTable {
  let builtins : Map[String, Unit] = {}
  for name in builtin_types {
    builtins[name] = ()
  }
  { types: {}, ids: {}, constructors: {}, functions: {}, builtins }
}

///|
/// Built-in types that need no declaration.
let builtin_types : Array[String] = [
  "Int", "Long", "Double", "String", "Bytes", "Int128", "Int256", "Bool", "True",
  "False", "Vector", "Object", "Function", "#", "Type",
  // lowercase aliases commonly used
   "int", "long", "double", "string", "bytes", "int128", "int256", "true", "false",
  "vector",
]

///|
/// Returns the full name of a type identifier.
pub fn type_ident_full_name(ident : @ast.TypeIdent) -> String {
  match ident.ns {
    Some(ns) => ns.value + "." + ident.name.value
    None => ident.name.value
  }
}

///|
/// Returns the full name of a combinator.
pub fn combinator_full_name(c : @ast.Combinator) -> String {
  match c.ns {
    Some(ns) => ns.value + "." + c.name.value
    None => c.name.value
  }
}
