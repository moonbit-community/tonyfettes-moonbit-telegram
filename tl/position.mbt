///|
pub struct Position {
  line : Int
  column : Int
  offset : Int
} derive(Show, Eq)

///|
pub fn Position::new(line~ : Int, column~ : Int, offset~ : Int) -> Position {
  { line, column, offset }
}

///|
pub struct Span {
  start : Position
  end : Position
} derive(Show, Eq)

///|
pub fn Span::new(start~ : Position, end~ : Position) -> Span {
  { start, end }
}
