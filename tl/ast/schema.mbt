///|
pub(all) struct Schema {
  types : Array[Declaration]
  functions : Array[Combinator]
  comments : Array[(Span, String)] // Preserved comments
} derive(Show)

///|
/// Custom equality that ignores comments field for property-based testing.
pub impl Eq for Schema with equal(self, other) {
  self.types == other.types && self.functions == other.functions
  // Intentionally ignoring comments as they involve Span
}

///|
pub fn Schema::new() -> Schema {
  { types: [], functions: [], comments: [] }
}
