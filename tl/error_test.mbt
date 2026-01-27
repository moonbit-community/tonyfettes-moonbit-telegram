///|
test "TLParseError::UnexpectedChar creation and display" {
  let pos : @tl.Position = { line: 1, column: 5, offset: 4 }
  let err = @tl.TLParseError::UnexpectedChar(pos~, char='@')
  inspect(
    err,
    content="UnexpectedChar(pos={line: 1, column: 5, offset: 4}, char=@)",
  )
}

///|
test "TLParseError::UnexpectedToken creation and display" {
  let pos : @tl.Position = { line: 2, column: 10, offset: 25 }
  let err = @tl.TLParseError::UnexpectedToken(
    pos~,
    expected="identifier",
    found="number",
  )
  inspect(
    err,
    content="UnexpectedToken(pos={line: 2, column: 10, offset: 25}, expected=identifier, found=number)",
  )
}

///|
test "TLParseError::UnexpectedEof creation and display" {
  let pos : @tl.Position = { line: 10, column: 1, offset: 100 }
  let err = @tl.TLParseError::UnexpectedEof(pos~)
  inspect(err, content="UnexpectedEof(pos={line: 10, column: 1, offset: 100})")
}

///|
test "TLParseError::InvalidHexId creation and display" {
  let pos : @tl.Position = { line: 3, column: 15, offset: 50 }
  let err = @tl.TLParseError::InvalidHexId(pos~, value="0xZZZZ")
  inspect(
    err,
    content="InvalidHexId(pos={line: 3, column: 15, offset: 50}, value=0xZZZZ)",
  )
}

///|
test "TLParseError::InvalidNumber creation and display" {
  let pos : @tl.Position = { line: 5, column: 8, offset: 75 }
  let err = @tl.TLParseError::InvalidNumber(pos~, value="12abc")
  inspect(
    err,
    content="InvalidNumber(pos={line: 5, column: 8, offset: 75}, value=12abc)",
  )
}

///|
test "Position equality" {
  let pos1 : @tl.Position = { line: 1, column: 1, offset: 0 }
  let pos2 : @tl.Position = { line: 1, column: 1, offset: 0 }
  let pos3 : @tl.Position = { line: 2, column: 1, offset: 10 }
  assert_true(pos1 == pos2)
  assert_true(pos1 != pos3)
}
