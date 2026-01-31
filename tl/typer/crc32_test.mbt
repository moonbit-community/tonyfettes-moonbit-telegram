///|
test "crc32: empty string" {
  inspect(crc32(""), content="0")
}

///|
test "crc32: standard test vector" {
  // Standard CRC32 test vector: CRC32("123456789") = 0xCBF43926 = 3421780262
  inspect(crc32("123456789"), content="3421780262")
}

///|
test "crc32: simple string" {
  // CRC32("hello") = 0x3610A686 = 907060870
  inspect(crc32("hello"), content="907060870")
}

///|
test "normalize_combinator: simple" {
  let pos = @ast.Position::new(line=0, column=0, offset=0)
  let span = @ast.Span::new(start=pos, end=pos)
  let c : @ast.Combinator = {
    ns: None,
    name: @ast.LowerIdent::new(value="foo"),
    id: Some(@ast.ConstructorId::new(value=0x12345678)),
    opt_args: [],
    args: [
      @ast.Arg::Named({
        name: @ast.LowerIdent::new(value="x"),
        conditional: None,
        bang: false,
        type_: @ast.Term::Var(@ast.LowerIdent::new(value="int")),
      }),
    ],
    result: { type_ident: { ns: None, name: @ast.UpperIdent::new(value="Foo") }, params: [] },
    span,
  }
  // Should not include #id in normalized form
  inspect(normalize_combinator(c), content="foo x:int = Foo;")
}

///|
test "typer: combinator without id gets computed id" {
  let tokens = @lexer.Lexer::new(source="foo x:int = Foo;").tokenize()
  let schema = @parser.Parser::new(tokens).parse_schema()
  let table = type_schema(schema)
  guard table.constructors.get("foo") is Some(_) else {
    fail("expected foo constructor")
  }
  // The ID should be computed and stored
  assert_true(table.ids.length() > 0)
  // Verify the ID is the CRC32 of the normalized form
  let expected_id = crc32("foo x:int = Foo;")
  assert_true(table.ids.contains(expected_id))
}

///|
test "typer: function without id gets computed id" {
  let source =
    #|int = Int;
    #|---functions---
    #|getInt = Int;
  let tokens = @lexer.Lexer::new(source~).tokenize()
  let schema = @parser.Parser::new(tokens).parse_schema()
  let table = type_schema(schema)
  guard table.functions.get("getInt") is Some(_) else {
    fail("expected getInt function")
  }
  // The ID should be computed and stored
  let expected_id = crc32("getInt = Int;")
  assert_true(table.ids.contains(expected_id))
}
