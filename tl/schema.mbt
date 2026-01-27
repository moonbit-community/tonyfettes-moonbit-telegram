///|
pub(all) struct Schema {
  types : Array[Declaration]
  functions : Array[Combinator]
  comments : Array[(Span, String)] // Preserved comments
} derive(Show, Eq)

///|
pub fn Schema::new() -> Schema {
  { types: [], functions: [], comments: [] }
}
