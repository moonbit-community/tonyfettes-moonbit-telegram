///|
test "Position creation" {
  let pos = Position::new(line=1, column=5, offset=4)
  inspect(pos.line, content="1")
  inspect(pos.column, content="5")
  inspect(pos.offset, content="4")
}

///|
test "Position equality" {
  let pos1 = Position::new(line=1, column=1, offset=0)
  let pos2 = Position::new(line=1, column=1, offset=0)
  let pos3 = Position::new(line=2, column=1, offset=10)
  assert_true(pos1 == pos2)
  assert_false(pos1 == pos3)
}

///|
test "Span creation" {
  let start = Position::new(line=1, column=1, offset=0)
  let end = Position::new(line=1, column=10, offset=9)
  let span = Span::new(start~, end~)
  inspect(span.start.line, content="1")
  inspect(span.start.column, content="1")
  inspect(span.end.line, content="1")
  inspect(span.end.column, content="10")
}

///|
test "Span equality" {
  let start1 = Position::new(line=1, column=1, offset=0)
  let end1 = Position::new(line=1, column=5, offset=4)
  let span1 = Span::new(start=start1, end=end1)
  let start2 = Position::new(line=1, column=1, offset=0)
  let end2 = Position::new(line=1, column=5, offset=4)
  let span2 = Span::new(start=start2, end=end2)
  let start3 = Position::new(line=2, column=1, offset=10)
  let end3 = Position::new(line=2, column=5, offset=14)
  let span3 = Span::new(start=start3, end=end3)
  assert_true(span1 == span2)
  assert_false(span1 == span3)
}
