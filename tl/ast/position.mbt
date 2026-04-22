///|
/// A position in the source text.
pub(all) struct Position {
  line : Int
  column : Int
  offset : Int
} derive(Debug, Eq)

///|
/// Creates a new Position with labeled arguments.
pub fn Position::new(line~ : Int, column~ : Int, offset~ : Int) -> Position {
  { line, column, offset }
}

///|
/// A span in the source text.
pub(all) struct Span {
  start : Position
  end : Position
} derive(Debug, Eq)

///|
/// Creates a new Span with labeled arguments.
pub fn Span::new(start~ : Position, end~ : Position) -> Span {
  { start, end }
}
