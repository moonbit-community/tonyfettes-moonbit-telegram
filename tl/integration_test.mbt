///|
test "Integration: basic types" {
  let source =
    #|int = Int;
    #|long = Long;
    #|string = String;
  let schema = parse(source~)
  inspect(schema.types.length(), content="3")
}

///|
test "Integration: vector definition" {
  let source = "vector {t:Type} # [t] = Vector t;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="vector")
  inspect(c.opt_args.length(), content="1")
}

///|
test "Integration: int128 multiplicity" {
  let source = "int128 4*[ int ] = Int128;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.args[0] is Multiplicity(m) else { fail("expected Multiplicity") }
  guard m.count is Const(4) else { fail("expected count 4") }
}

///|
test "Integration: user with flags" {
  let source =
    #|user#d23c81a3 flags:# id:long first_name:flags.0?string
    #|  last_name:flags.1?string photo:flags.5?UserProfilePhoto = User;
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="user")
  guard c.id is Some(_) else { fail("expected hex id") }
  // Check conditional fields
  let mut conditional_count = 0
  for arg in c.args {
    if arg is Named(named) && named.conditional is Some(_) {
      conditional_count = conditional_count + 1
    }
  }
  assert_true(conditional_count >= 3)
}

///|
test "Integration: boolean flags" {
  let source = "message#abc flags:# out:flags.1?true mentioned:flags.4?true id:int = Message;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="message")
}

///|
test "Integration: namespaced definitions" {
  let source = "auth.sentCode#5e002502 phone_code_hash:string = auth.SentCode;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.ns is Some(ns) else { fail("expected namespace") }
  inspect(ns, content="auth")
  inspect(c.result.type_ident.ns, content="Some(\"auth\")")
}

///|
test "Integration: functions section" {
  let source =
    #|user = User;
    #|---functions---
    #|auth.sendCode#a677244f phone:string = auth.SentCode;
  let schema = parse(source~)
  inspect(schema.types.length(), content="1")
  inspect(schema.functions.length(), content="1")
  inspect(schema.functions[0].name, content="sendCode")
}

///|
test "Integration: final declarations" {
  let source =
    #|New UserStatus;
    #|Final UserStatus;
    #|Empty SomeUnusedType;
  let schema = parse(source~)
  inspect(schema.types.length(), content="3")
  guard schema.types[0] is Final(@ast.FinalDecl::New(_)) else {
    fail("expected New")
  }
}

///|
test "Integration: tuple definition" {
  let source = "tuple {t:Type} {n:#} [t] = Tuple t n;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.opt_args.length(), content="2")
  guard c.opt_args[1].type_ is Nat else { fail("expected Nat type") }
}

///|
test "Integration: complex schema" {
  let source =
    #|// Built-in types
    #|int = Int;
    #|vector {t:Type} # [t] = Vector t;
    #|
    #|// User types
    #|user#d23c81a3 flags:# id:long first_name:flags.0?string = User;
    #|
    #|---functions---
    #|getUser id:long = User;
    #|
    #|---types---
    #|New UserStatus;
  let schema = parse(source~)
  // Should parse without error
  assert_true(schema.types.length() >= 3)
  assert_true(schema.functions.length() >= 1)
  // Comments should be preserved
  assert_true(schema.comments.length() >= 1)
}

///|
test "Integration: percent bare type" {
  let source = "vectorTotal {t:Type} total:int vector:%Vector = VectorTotal t;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.args[1] is Named(arg) else { fail("expected Named arg") }
  guard arg.type_ is Percent(_) else { fail("expected Percent type") }
}

///|
test "Integration: bang bare type in args" {
  let source = "draftMessage#abc reply_to:!InputReplyTo message:string = DraftMessage;"
  let schema = parse(source~)
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.args[0] is Named(arg) else { fail("expected Named arg") }
  inspect(arg.bang, content="true")
}

///|
test "Integration: parse and schema_to_string roundtrip" {
  let source = "user id:long name:string = User;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  // Parse again to verify it's valid
  let schema2 = parse(source=output)
  inspect(schema2.types.length(), content="1")
  guard schema2.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="user")
}

///|
test "Integration: schema_to_string with hex id" {
  let source = "user#d23c81a3 id:long = User;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("#d23c81a3"))
}

///|
test "Integration: schema_to_string with optional args" {
  let source = "vector {t:Type} # [t] = Vector t;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("{t:Type}"))
}

///|
test "Integration: schema_to_string with functions section" {
  let source =
    #|user = User;
    #|---functions---
    #|getUser id:long = User;
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("---functions---"))
  assert_true(output.contains("getUser"))
}

///|
test "Integration: schema_to_string with final declarations" {
  let source = "New UserStatus;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("New UserStatus;"))
}

///|
test "Integration: schema_to_string with conditional" {
  let source = "user flags:# name:flags.0?string = User;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("flags.0?"))
}

///|
test "Integration: schema_to_string with multiplicity" {
  let source = "int128 4*[int] = Int128;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("4*["))
}

///|
test "Integration: schema_to_string with grouped args" {
  let source = "point (x y:Int) = Point;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("(x y:Int)"))
}

///|
test "Integration: schema_to_string with namespace" {
  let source = "auth.sentCode hash:string = auth.SentCode;"
  let schema = parse(source~)
  let output = schema_to_string(schema)
  assert_true(output.contains("auth.sentCode"))
  assert_true(output.contains("auth.SentCode"))
}

///|
async test "Integration: parse Telegram MTProto schema" {
  let source = @fs.read_file("tl/testdata/api.tl").text()
  let schema = parse(source~)
  println("Types: \{schema.types.length()}")
  println("Functions: \{schema.functions.length()}")
  // Expect substantial number of types and functions
  assert_true(schema.types.length() > 1000)
  assert_true(schema.functions.length() > 500)
}

///|
async test "Integration: type Telegram MTProto schema" {
  let source = @fs.read_file("tl/testdata/api.tl").text()
  let schema = parse(source~)
  let table = type_schema(schema)
  println("Resolved types: \{table.types.length()}")
  println("Constructors: \{table.constructors.length()}")
  println("Constructor IDs: \{table.ids.length()}")
  // Expect substantial number of resolved types
  assert_true(table.types.length() > 500)
}
