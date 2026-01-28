///|
/// Helper to parse TL source into a schema
fn parse_tl(source : String) -> @ast.Schema raise @error.TLParseError {
  let lexer = @lexer.Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = @parser.Parser::new(tokens)
  parser.parse_schema()
}

///|
test "typer: valid simple schema" {
  let schema = parse_tl("user id:long = User;")
  let table = type_schema(schema)
  assert_true(table.types.contains("User"))
  guard table.types.get("User") is Some(resolved) else {
    fail("expected User type")
  }
  assert_eq(resolved.constructors.length(), 1)
}

///|
test "typer: undefined type" {
  let schema = parse_tl("foo x:Bar = Foo;")
  let result = try? type_schema(schema)
  guard result is Err(UndefinedType(name="Bar", ..)) else {
    fail("expected UndefinedType error for Bar, got \{result}")
  }
}

///|
test "typer: duplicate constructor id allowed" {
  // Telegram schema allows duplicate IDs (e.g., prefix versions and real versions)
  let schema = parse_tl("foo#abc = Foo;\nbar#abc = Bar;")
  let table = type_schema(schema)
  // Later declaration wins
  guard table.ids.get(0xabc) is Some(c) else {
    fail("expected constructor with id #abc")
  }
  assert_eq(combinator_full_name(c), "bar")
}

///|
test "typer: duplicate constructor name" {
  let schema = parse_tl("foo = Foo;\nfoo = Bar;")
  let result = try? type_schema(schema)
  guard result is Err(DuplicateConstructorName(name="foo", ..)) else {
    fail("expected DuplicateConstructorName error, got \{result}")
  }
}

///|
test "typer: builtin types" {
  let schema = parse_tl("user id:long name:string active:Bool = User;")
  let table = type_schema(schema)
  assert_true(table.types.contains("User"))
}

///|
test "typer: type variable in generic" {
  let schema = parse_tl("vector {t:Type} # [t] = Vector t;")
  let table = type_schema(schema)
  assert_true(table.types.contains("Vector"))
}

///|
test "typer: unbound type variable" {
  let schema = parse_tl("foo x:t = Foo;")
  let result = try? type_schema(schema)
  guard result is Err(UnboundTypeVariable(variable="t", ..)) else {
    fail("expected UnboundTypeVariable error, got \{result}")
  }
}

///|
test "typer: flags field reference" {
  let schema = parse_tl("user flags:# name:flags.0?string = User;")
  let table = type_schema(schema)
  assert_true(table.types.contains("User"))
}

///|
test "typer: undefined flags field" {
  let schema = parse_tl("user name:flags.0?string = User;")
  let result = try? type_schema(schema)
  guard result is Err(UndefinedFlagsField(conditional="flags", ..)) else {
    fail("expected UndefinedFlagsField error, got \{result}")
  }
}

///|
test "typer: nat variable in result type" {
  let schema = parse_tl("tuple {t:Type} {n:#} [t] = Tuple t n;")
  let table = type_schema(schema)
  assert_true(table.types.contains("Tuple"))
}

///|
test "typer: unbound variable in result" {
  // Using an undefined variable n in result type
  // Parser can't distinguish nat/type vars, so it's reported as a type variable
  let schema = parse_tl("tuple {t:Type} [t] = Tuple t n;")
  let result = try? type_schema(schema)
  guard result is Err(UnboundTypeVariable(variable="n", ..)) else {
    fail("expected UnboundTypeVariable error, got \{result}")
  }
}

///|
test "typer: multiple constructors for same type" {
  let source =
    #|userStatusOnline = UserStatus;
    #|userStatusOffline = UserStatus;
  let schema = parse_tl(source)
  let table = type_schema(schema)
  assert_true(table.types.contains("UserStatus"))
  guard table.types.get("UserStatus") is Some(resolved) else {
    fail("expected UserStatus type")
  }
  assert_eq(resolved.constructors.length(), 2)
}

///|
test "typer: namespaced types" {
  let schema = parse_tl("auth.sentCode hash:string = auth.SentCode;")
  let table = type_schema(schema)
  assert_true(table.types.contains("auth.SentCode"))
  assert_true(table.constructors.contains("auth.sentCode"))
}

///|
test "typer: type application Vector<int>" {
  let schema = parse_tl("users list:Vector<int> = Users;")
  let table = type_schema(schema)
  assert_true(table.types.contains("Users"))
}

///|
test "typer: final declaration" {
  let source =
    #|userStatusOnline = UserStatus;
    #|Final UserStatus;
  let schema = parse_tl(source)
  let table = type_schema(schema)
  guard table.types.get("UserStatus") is Some(resolved) else {
    fail("expected UserStatus type")
  }
  assert_true(resolved.is_final)
}

///|
test "typer: empty declaration" {
  let schema = parse_tl("Empty UnusedType;")
  let table = type_schema(schema)
  guard table.types.get("UnusedType") is Some(resolved) else {
    fail("expected UnusedType type")
  }
  assert_true(resolved.is_empty)
}

///|
test "typer: functions section" {
  let source =
    #|user id:long = User;
    #|---functions---
    #|getUser id:long = User;
  let schema = parse_tl(source)
  let table = type_schema(schema)
  assert_true(table.functions.contains("getUser"))
  assert_true(not(table.constructors.contains("getUser")))
}

///|
test "typer: function return type must be declared" {
  let source =
    #|---functions---
    #|getFoo = Missing;
  let schema = parse_tl(source)
  let result = try? type_schema(schema)
  guard result is Err(UndefinedType(name="Missing", ..)) else {
    fail("expected UndefinedType error for Missing, got \{result}")
  }
}

///|
test "typer: bang type modifier" {
  let schema = parse_tl(
    "draft reply:!InputReplyTo = Draft;\ninputReplyTo = InputReplyTo;",
  )
  let table = type_schema(schema)
  assert_true(table.types.contains("Draft"))
}

///|
test "typer: percent type modifier" {
  let schema = parse_tl(
    "vectorTotal vector:%Vector = VectorTotal;\nvector = Vector;",
  )
  let table = type_schema(schema)
  assert_true(table.types.contains("VectorTotal"))
}

///|
test "typer: unused type parameter" {
  let schema = parse_tl("foo {t:Type} x:int = Foo;")
  let result = try? type_schema(schema)
  guard result is Err(UnusedOptionalParameter(variable="t", ..)) else {
    fail("expected UnusedOptionalParameter error, got \{result}")
  }
}

///|
test "typer: unused nat parameter" {
  let schema = parse_tl("foo {n:#} x:int = Foo;")
  let result = try? type_schema(schema)
  guard result is Err(UnusedOptionalParameter(variable="n", ..)) else {
    fail("expected UnusedOptionalParameter error, got \{result}")
  }
}

///|
test "typer: used type parameter is valid" {
  let schema = parse_tl("foo {t:Type} x:t = Foo t;")
  let table = type_schema(schema)
  assert_true(table.types.contains("Foo"))
}

///|
test "typer: used nat parameter is valid" {
  let schema = parse_tl("foo {n:#} x:Vector<int> = Foo n;")
  let table = type_schema(schema)
  assert_true(table.types.contains("Foo"))
}
