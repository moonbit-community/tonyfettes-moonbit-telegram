///|
test "TokenKind::to_string for identifiers" {
  inspect(
    TokenKind::LowerIdent("user").to_string(),
    content="identifier 'user'",
  )
  inspect(
    TokenKind::UpperIdent("User").to_string(),
    content="identifier 'User'",
  )
  inspect(
    TokenKind::LowerIdent("first_name").to_string(),
    content="identifier 'first_name'",
  )
}

///|
test "TokenKind::to_string for literals" {
  inspect(
    TokenKind::HexNumber(0xd23c81a3).to_string(),
    content="hex number '3527180707'",
  )
  inspect(TokenKind::Number(123).to_string(), content="number '123'")
}

///|
test "TokenKind::to_string for punctuation" {
  inspect(TokenKind::Hash.to_string(), content="'#'")
  inspect(TokenKind::Colon.to_string(), content="':'")
  inspect(TokenKind::Semicolon.to_string(), content="';'")
  inspect(TokenKind::Equals.to_string(), content="'='")
  inspect(TokenKind::Question.to_string(), content="'?'")
  inspect(TokenKind::Dot.to_string(), content="'.'")
  inspect(TokenKind::LParen.to_string(), content="'('")
  inspect(TokenKind::RParen.to_string(), content="')'")
  inspect(TokenKind::LBracket.to_string(), content="'['")
  inspect(TokenKind::RBracket.to_string(), content="']'")
  inspect(TokenKind::LBrace.to_string(), content="'{'")
  inspect(TokenKind::RBrace.to_string(), content="'}'")
  inspect(TokenKind::LAngle.to_string(), content="'<'")
  inspect(TokenKind::RAngle.to_string(), content="'>'")
  inspect(TokenKind::Percent.to_string(), content="'%'")
  inspect(TokenKind::Bang.to_string(), content="'!'")
  inspect(TokenKind::Star.to_string(), content="'*'")
  inspect(TokenKind::Plus.to_string(), content="'+'")
  inspect(TokenKind::Comma.to_string(), content="','")
  inspect(TokenKind::Underscore.to_string(), content="'_'")
}

///|
test "TokenKind::to_string for section separators and keywords" {
  inspect(TokenKind::TripleDash.to_string(), content="'---'")
  inspect(TokenKind::Functions.to_string(), content="'functions'")
  inspect(TokenKind::Types.to_string(), content="'types'")
  inspect(TokenKind::Final.to_string(), content="'Final'")
  inspect(TokenKind::New.to_string(), content="'New'")
  inspect(TokenKind::Empty.to_string(), content="'Empty'")
}

///|
test "TokenKind::to_string for comments" {
  inspect(
    TokenKind::LineComment(" this is a comment").to_string(),
    content="line comment ' this is a comment'",
  )
  inspect(
    TokenKind::BlockComment(" block\ncomment ").to_string(),
    content="block comment ' block\ncomment '",
  )
}

///|
test "TokenKind::to_string for Eof" {
  inspect(TokenKind::Eof.to_string(), content="end of file")
}

///|
test "Token creation" {
  let start = Position::{ line: 1, column: 1, offset: 0 }
  let end = Position::{ line: 1, column: 5, offset: 4 }
  let span = Span::{ start, end }
  let token = Token::{ kind: TokenKind::LowerIdent("user"), span }
  inspect(token.kind, content="LowerIdent(\"user\")")
  inspect(token.span.start.line, content="1")
  inspect(token.span.start.column, content="1")
  inspect(token.span.end.column, content="5")
}

///|
test "Position and Span creation" {
  let pos = Position::{ line: 10, column: 5, offset: 100 }
  inspect(pos.line, content="10")
  inspect(pos.column, content="5")
  inspect(pos.offset, content="100")
  let span = Span::{
    start: pos,
    end: Position::{ line: 10, column: 10, offset: 105 },
  }
  inspect(span.start.offset, content="100")
  inspect(span.end.offset, content="105")
}

///|
test "TokenKind equality" {
  assert_true(TokenKind::Hash == TokenKind::Hash)
  assert_true(TokenKind::LowerIdent("foo") == TokenKind::LowerIdent("foo"))
  assert_true(TokenKind::LowerIdent("foo") != TokenKind::LowerIdent("bar"))
  assert_true(TokenKind::Number(42) == TokenKind::Number(42))
  assert_true(TokenKind::HexNumber(0xff) == TokenKind::HexNumber(255))
}
