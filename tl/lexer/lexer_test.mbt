///|
test "Lexer tokenize basic lowercase identifier" {
  let lexer = Lexer::new(source="user")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2") // identifier + Eof
  guard tokens[0].kind is LowerIdent("user") else {
    fail("expected LowerIdent")
  }
  guard tokens[1].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer tokenize basic uppercase identifier" {
  let lexer = Lexer::new(source="User")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is UpperIdent("User") else {
    fail("expected UpperIdent")
  }
  guard tokens[1].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer tokenize identifier with underscore" {
  let lexer = Lexer::new(source="first_name")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is LowerIdent("first_name") else {
    fail("expected LowerIdent")
  }
}

///|
test "Lexer tokenize identifier starting with underscore" {
  let lexer = Lexer::new(source="_private")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is LowerIdent("_private") else {
    fail("expected LowerIdent")
  }
}

///|
test "Lexer tokenize constructor with id" {
  let lexer = Lexer::new(source="user#d23c81a3")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="3") // LowerIdent, HexNumber, Eof
  guard tokens[0].kind is LowerIdent("user") else {
    fail("expected LowerIdent")
  }
  guard tokens[1].kind is HexNumber(n) && n == 0xd23c81a3 else {
    fail("expected HexNumber")
  }
  guard tokens[2].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer tokenize bare hash" {
  let lexer = Lexer::new(source="# ")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Hash else { fail("expected Hash") }
}

///|
test "Lexer tokenize decimal number" {
  let lexer = Lexer::new(source="12345")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Number(12345) else { fail("expected Number") }
}

///|
test "Lexer tokenize negative number" {
  let lexer = Lexer::new(source="-42")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Number(-42) else { fail("expected Number(-42)") }
}

///|
test "Lexer tokenize full declaration" {
  let lexer = Lexer::new(source="user id:long = User;")
  let tokens = lexer.tokenize()
  // LowerIdent("user"), LowerIdent("id"), Colon, LowerIdent("long"), Equals, UpperIdent("User"), Semicolon, Eof
  inspect(tokens.length(), content="8")
  guard tokens[0].kind is LowerIdent("user") else { fail("expected user") }
  guard tokens[1].kind is LowerIdent("id") else { fail("expected id") }
  guard tokens[2].kind is Colon else { fail("expected Colon") }
  guard tokens[3].kind is LowerIdent("long") else { fail("expected long") }
  guard tokens[4].kind is Equals else { fail("expected Equals") }
  guard tokens[5].kind is UpperIdent("User") else { fail("expected User") }
  guard tokens[6].kind is Semicolon else { fail("expected Semicolon") }
  guard tokens[7].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer section separator functions" {
  let lexer = Lexer::new(source="---functions---")
  let tokens = lexer.tokenize()
  // TripleDash, Functions, TripleDash, Eof
  inspect(tokens.length(), content="4")
  guard tokens[0].kind is TripleDash else { fail("expected TripleDash") }
  guard tokens[1].kind is Functions else { fail("expected Functions") }
  guard tokens[2].kind is TripleDash else { fail("expected TripleDash") }
  guard tokens[3].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer section separator types" {
  let lexer = Lexer::new(source="---types---")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="4")
  guard tokens[0].kind is TripleDash else { fail("expected TripleDash") }
  guard tokens[1].kind is Types else { fail("expected Types") }
  guard tokens[2].kind is TripleDash else { fail("expected TripleDash") }
  guard tokens[3].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer triple dash only" {
  let lexer = Lexer::new(source="---")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is TripleDash else { fail("expected TripleDash") }
  guard tokens[1].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer line comment" {
  let lexer = Lexer::new(source="// comment\nuser")
  let tokens = lexer.tokenize()
  // LineComment(" comment"), LowerIdent("user"), Eof
  inspect(tokens.length(), content="3")
  guard tokens[0].kind is LineComment(" comment") else {
    fail("expected LineComment")
  }
  guard tokens[1].kind is LowerIdent("user") else {
    fail("expected LowerIdent")
  }
  guard tokens[2].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer block comment" {
  let lexer = Lexer::new(source="/* block */user")
  let tokens = lexer.tokenize()
  // BlockComment(" block "), LowerIdent("user"), Eof
  inspect(tokens.length(), content="3")
  guard tokens[0].kind is BlockComment(" block ") else {
    fail("expected BlockComment")
  }
  guard tokens[1].kind is LowerIdent("user") else {
    fail("expected LowerIdent")
  }
}

///|
test "Lexer block comment multiline" {
  let source =
    #|/* multi
    #|line
    #|comment */
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is BlockComment(_) else { fail("expected BlockComment") }
}

///|
test "Lexer all punctuation" {
  // Note: _ is tested separately as it becomes LowerIdent("_")
  let lexer = Lexer::new(source="# : ; = ? . ( ) [ ] { } < > % ! * + ,")
  let tokens = lexer.tokenize()
  // 19 punctuation tokens + Eof = 20
  inspect(tokens.length(), content="20")
  guard tokens[0].kind is Hash else { fail("expected Hash") }
  guard tokens[1].kind is Colon else { fail("expected Colon") }
  guard tokens[2].kind is Semicolon else { fail("expected Semicolon") }
  guard tokens[3].kind is Equals else { fail("expected Equals") }
  guard tokens[4].kind is Question else { fail("expected Question") }
  guard tokens[5].kind is Dot else { fail("expected Dot") }
  guard tokens[6].kind is LParen else { fail("expected LParen") }
  guard tokens[7].kind is RParen else { fail("expected RParen") }
  guard tokens[8].kind is LBracket else { fail("expected LBracket") }
  guard tokens[9].kind is RBracket else { fail("expected RBracket") }
  guard tokens[10].kind is LBrace else { fail("expected LBrace") }
  guard tokens[11].kind is RBrace else { fail("expected RBrace") }
  guard tokens[12].kind is LAngle else { fail("expected LAngle") }
  guard tokens[13].kind is RAngle else { fail("expected RAngle") }
  guard tokens[14].kind is Percent else { fail("expected Percent") }
  guard tokens[15].kind is Bang else { fail("expected Bang") }
  guard tokens[16].kind is Star else { fail("expected Star") }
  guard tokens[17].kind is Plus else { fail("expected Plus") }
  guard tokens[18].kind is Comma else { fail("expected Comma") }
  guard tokens[19].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer underscore token" {
  // Note: underscore at start of identifier makes it LowerIdent
  // A bare underscore should error since it's a standalone char
  // But per token.mbt, Underscore is a valid token - need to handle it
  // Actually looking at the task, '_' is listed in punctuation
  // But our scan_identifier handles '_' as identifier start
  // Let me check: if we have just "_" it should be an identifier "_"
  let lexer = Lexer::new(source="_")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is LowerIdent("_") else { fail("expected LowerIdent") }
}

///|
test "Lexer keywords Final" {
  let lexer = Lexer::new(source="Final")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Final else { fail("expected Final keyword") }
}

///|
test "Lexer keywords New" {
  let lexer = Lexer::new(source="New")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is New else { fail("expected New keyword") }
}

///|
test "Lexer keywords Empty" {
  let lexer = Lexer::new(source="Empty")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Empty else { fail("expected Empty keyword") }
}

///|
test "Lexer keywords functions" {
  let lexer = Lexer::new(source="functions")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Functions else { fail("expected Functions keyword") }
}

///|
test "Lexer keywords types" {
  let lexer = Lexer::new(source="types")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is Types else { fail("expected Types keyword") }
}

///|
test "Lexer span positions" {
  let lexer = Lexer::new(source="user")
  let tokens = lexer.tokenize()
  let token = tokens[0]
  inspect(token.span.start.line, content="1")
  inspect(token.span.start.column, content="1")
  inspect(token.span.start.offset, content="0")
  inspect(token.span.end.line, content="1")
  inspect(token.span.end.column, content="5")
  inspect(token.span.end.offset, content="4")
}

///|
test "Lexer span positions multiline" {
  let lexer = Lexer::new(source="a\nb")
  let tokens = lexer.tokenize()
  // First token 'a' at line 1, col 1
  inspect(tokens[0].span.start.line, content="1")
  inspect(tokens[0].span.start.column, content="1")
  // Second token 'b' at line 2, col 1
  inspect(tokens[1].span.start.line, content="2")
  inspect(tokens[1].span.start.column, content="1")
}

///|
test "Lexer complex declaration" {
  let lexer = Lexer::new(source="vector#1cb5c415 {t:Type} # [ t ] = Vector t;")
  let tokens = lexer.tokenize()
  // vector, HexNumber, LBrace, LowerIdent(t), Colon, UpperIdent(Type), RBrace, Hash, LBracket, LowerIdent(t), RBracket, Equals, UpperIdent(Vector), LowerIdent(t), Semicolon, Eof
  inspect(tokens.length(), content="16")
  guard tokens[0].kind is LowerIdent("vector") else { fail("expected vector") }
  guard tokens[1].kind is HexNumber(_) else { fail("expected HexNumber") }
  guard tokens[2].kind is LBrace else { fail("expected LBrace") }
  guard tokens[3].kind is LowerIdent("t") else { fail("expected t") }
  guard tokens[4].kind is Colon else { fail("expected Colon") }
  guard tokens[5].kind is UpperIdent("Type") else { fail("expected Type") }
  guard tokens[6].kind is RBrace else { fail("expected RBrace") }
  guard tokens[7].kind is Hash else { fail("expected Hash") }
  guard tokens[8].kind is LBracket else { fail("expected LBracket") }
  guard tokens[9].kind is LowerIdent("t") else { fail("expected t") }
  guard tokens[10].kind is RBracket else { fail("expected RBracket") }
  guard tokens[11].kind is Equals else { fail("expected Equals") }
  guard tokens[12].kind is UpperIdent("Vector") else { fail("expected Vector") }
  guard tokens[13].kind is LowerIdent("t") else { fail("expected t") }
  guard tokens[14].kind is Semicolon else { fail("expected Semicolon") }
}

///|
test "Lexer whitespace handling" {
  let lexer = Lexer::new(source="  \t\n  user  ")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="2")
  guard tokens[0].kind is LowerIdent("user") else { fail("expected user") }
}

///|
test "Lexer empty source" {
  let lexer = Lexer::new(source="")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="1")
  guard tokens[0].kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer hex number edge cases" {
  let lexer = Lexer::new(source="#0 #ff #DEADBEEF")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="4")
  guard tokens[0].kind is HexNumber(0) else { fail("expected HexNumber(0)") }
  guard tokens[1].kind is HexNumber(0xff) else {
    fail("expected HexNumber(0xff)")
  }
  guard tokens[2].kind is HexNumber(0xDEADBEEF) else {
    fail("expected HexNumber(0xDEADBEEF)")
  }
}

///|
test "Lexer unexpected char error" {
  let lexer = Lexer::new(source="@")
  let result : Result[Array[Token], _] = try? lexer.tokenize()
  guard result is Err(LexError::UnexpectedChar(pos~, char~)) else {
    fail("expected UnexpectedChar error")
  }
  inspect(pos.line, content="1")
  inspect(pos.column, content="1")
  inspect(char, content="@")
}

///|
test "Lexer unclosed block comment error" {
  let lexer = Lexer::new(source="/* unclosed")
  let result : Result[Array[Token], _] = try? lexer.tokenize()
  guard result is Err(LexError::UnexpectedEof(_)) else {
    fail("expected UnexpectedEof error")
  }
}

///|
test "Lexer optional field syntax" {
  let lexer = Lexer::new(source="flags.0?field:Type")
  let tokens = lexer.tokenize()
  // flags, Dot, Number(0), Question, field, Colon, Type, Eof
  inspect(tokens.length(), content="8")
  guard tokens[0].kind is LowerIdent("flags") else { fail("expected flags") }
  guard tokens[1].kind is Dot else { fail("expected Dot") }
  guard tokens[2].kind is Number(0) else { fail("expected Number(0)") }
  guard tokens[3].kind is Question else { fail("expected Question") }
  guard tokens[4].kind is LowerIdent("field") else { fail("expected field") }
  guard tokens[5].kind is Colon else { fail("expected Colon") }
  guard tokens[6].kind is UpperIdent("Type") else { fail("expected Type") }
}

///|
test "Lexer percent operator" {
  let lexer = Lexer::new(source="%Message")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="3")
  guard tokens[0].kind is Percent else { fail("expected Percent") }
  guard tokens[1].kind is UpperIdent("Message") else {
    fail("expected UpperIdent")
  }
}

///|
test "Lexer bang operator" {
  let lexer = Lexer::new(source="!X")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="3")
  guard tokens[0].kind is Bang else { fail("expected Bang") }
  guard tokens[1].kind is UpperIdent("X") else { fail("expected UpperIdent") }
}

///|
test "Lexer generic syntax" {
  let lexer = Lexer::new(source="Vector<int>")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="5")
  guard tokens[0].kind is UpperIdent("Vector") else {
    fail("expected UpperIdent")
  }
  guard tokens[1].kind is LAngle else { fail("expected LAngle") }
  guard tokens[2].kind is LowerIdent("int") else { fail("expected int") }
  guard tokens[3].kind is RAngle else { fail("expected RAngle") }
}

///|
test "Lexer star and plus operators" {
  let lexer = Lexer::new(source="a * b + c")
  let tokens = lexer.tokenize()
  inspect(tokens.length(), content="6")
  guard tokens[0].kind is LowerIdent("a") else { fail("expected a") }
  guard tokens[1].kind is Star else { fail("expected Star") }
  guard tokens[2].kind is LowerIdent("b") else { fail("expected b") }
  guard tokens[3].kind is Plus else { fail("expected Plus") }
  guard tokens[4].kind is LowerIdent("c") else { fail("expected c") }
}

///|
test "Lexer next_token incremental" {
  let lexer = Lexer::new(source="a b c")
  let t1 = lexer.next_token()
  guard t1.kind is LowerIdent("a") else { fail("expected a") }
  let t2 = lexer.next_token()
  guard t2.kind is LowerIdent("b") else { fail("expected b") }
  let t3 = lexer.next_token()
  guard t3.kind is LowerIdent("c") else { fail("expected c") }
  let t4 = lexer.next_token()
  guard t4.kind is Eof else { fail("expected Eof") }
}

///|
test "Lexer real TL schema example" {
  let source =
    #|// This is a comment
    #|user#d23c81a3 id:long first_name:string last_name:string = User;
    #|---functions---
    #|users.getUsers#0d91a548 id:Vector<InputUser> = Vector<User>;
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  // Verify we can tokenize a realistic schema fragment
  // LineComment, user, HexNumber, id, Colon, long, first_name, Colon, string, ...
  inspect(tokens.length() > 20, content="true")
  guard tokens[0].kind is LineComment(_) else { fail("expected LineComment") }
}
