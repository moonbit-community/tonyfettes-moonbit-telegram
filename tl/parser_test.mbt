///|
test "Parser simple combinator" {
  let lexer = Lexer::new(source="user id:long = User;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  inspect(schema.types.length(), content="1")
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="user")
  inspect(c.ns, content="None")
  inspect(c.args.length(), content="1")
  guard c.args[0] is Named(arg) else { fail("expected Named arg") }
  inspect(arg.name, content="id")
}

///|
test "Parser combinator with hex id" {
  let lexer = Lexer::new(source="user#d23c81a3 id:long = User;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.id is Some(id) else { fail("expected hex id") }
  inspect(id, content="3527180707")
}

///|
test "Parser optional args" {
  let lexer = Lexer::new(source="vector {t:Type} # [t] = Vector t;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.opt_args.length(), content="1")
  inspect(c.opt_args[0].names[0], content="t")
  guard c.opt_args[0].type_ is Ident(ident) else { fail("expected type ident") }
  inspect(ident.name, content="Type")
}

///|
test "Parser conditional field" {
  let lexer = Lexer::new(
    source="user flags:# first_name:flags.0?string = User;",
  )
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.args.length(), content="2")
  // First arg is flags:#
  guard c.args[0] is Named(flags_arg) else {
    fail("expected Named arg for flags")
  }
  inspect(flags_arg.name, content="flags")
  guard flags_arg.type_ is Nat else { fail("expected Nat type for flags") }
  // Second arg is first_name:flags.0?string
  guard c.args[1] is Named(name_arg) else {
    fail("expected Named arg for first_name")
  }
  inspect(name_arg.name, content="first_name")
  guard name_arg.conditional is Some(cond) else { fail("expected conditional") }
  inspect(cond.var_name, content="flags")
  inspect(cond.bit_index, content="Some(0)")
}

///|
test "Parser multiplicity" {
  let lexer = Lexer::new(source="int128 4*[ int ] = Int128;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.args.length(), content="1")
  guard c.args[0] is Multiplicity(mult) else {
    fail("expected Multiplicity arg")
  }
  guard mult.count is Const(4) else { fail("expected Const(4)") }
  inspect(mult.args.length(), content="1")
}

///|
test "Parser functions section" {
  let source = "user = User;\n---functions---\ngetUser = User;"
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  inspect(schema.types.length(), content="1")
  inspect(schema.functions.length(), content="1")
  guard schema.types[0] is Combinator(c1) else {
    fail("expected Combinator in types")
  }
  inspect(c1.name, content="user")
  inspect(schema.functions[0].name, content="getUser")
}

///|
test "Parser final declarations" {
  let source = "New UserStatus;\nFinal UserStatus;\nEmpty SomeType;"
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  inspect(schema.types.length(), content="3")
  guard schema.types[0] is Final(FinalDecl::New(_)) else {
    fail("expected New")
  }
  guard schema.types[1] is Final(FinalDecl::Final(_)) else {
    fail("expected Final")
  }
  guard schema.types[2] is Final(FinalDecl::Empty(_)) else {
    fail("expected Empty")
  }
}

///|
test "Parser namespaced combinator" {
  let lexer = Lexer::new(
    source="auth.sentCode phone_code_hash:string = auth.SentCode;",
  )
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.ns is Some(ns) else { fail("expected namespace") }
  inspect(ns, content="auth")
  inspect(c.name, content="sentCode")
  inspect(c.result.type_ident.ns, content="Some(\"auth\")")
  inspect(c.result.type_ident.name, content="SentCode")
}

///|
test "Parser grouped args" {
  let lexer = Lexer::new(source="point (x y : Int) = Point;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.args.length(), content="1")
  guard c.args[0] is Grouped(g) else { fail("expected Grouped arg") }
  inspect(g.names.length(), content="2")
  inspect(g.names[0], content="x")
  inspect(g.names[1], content="y")
}

///|
test "Parser type application" {
  let lexer = Lexer::new(source="result {t:Type} value:t = Result<t>;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.result.type_ident.name == "Result" else {
    fail("expected Result type")
  }
  inspect(c.result.params.length(), content="1")
}

///|
test "Parser anonymous multiplicity" {
  let lexer = Lexer::new(source="vector {t:Type} # [ t ] = Vector t;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  // Should have # as first arg and [t] as second arg
  inspect(c.args.length(), content="2")
  guard c.args[0] is Anonymous(Nat) else { fail("expected Anonymous Nat") }
  guard c.args[1] is Multiplicity(_) else { fail("expected Multiplicity") }
}

///|
test "Parser bang in named arg" {
  let lexer = Lexer::new(source="rpc {X:Type} query:!X = X;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.args[0] is Named(arg) else { fail("expected Named arg") }
  // The ! prefix sets the bang flag, not wraps in Bang type
  inspect(arg.bang, content="true")
  inspect(arg.type_, content="Ident({ns: None, name: \"X\"})")
}

///|
test "Parser percent type" {
  let lexer = Lexer::new(source="foo value:%Type = Foo;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  guard c.args[0] is Named(arg) else { fail("expected Named arg") }
  guard arg.type_ is Percent(_) else { fail("expected Percent type") }
}

///|
test "Parser comments preserved" {
  let source = "// This is a comment\nuser = User;"
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  inspect(schema.comments.length(), content="1")
  inspect(schema.comments[0].1, content=" This is a comment")
}

///|
test "Parser underscore combinator name" {
  let lexer = Lexer::new(source="_ = Null;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.name, content="_")
  inspect(c.ns, content="None")
}

///|
test "Parser result with space-separated params" {
  let lexer = Lexer::new(source="pair {X:Type} {Y:Type} a:X b:Y = Pair X Y;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.result.params.length(), content="2")
}

///|
test "Parser multiple optional args" {
  let lexer = Lexer::new(source="tuple {t:Type} {n:#} items:t = Tuple t n;")
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  guard schema.types[0] is Combinator(c) else { fail("expected Combinator") }
  inspect(c.opt_args.length(), content="2")
  inspect(c.opt_args[0].names[0], content="t")
  inspect(c.opt_args[1].names[0], content="n")
  guard c.opt_args[1].type_ is Nat else { fail("expected Nat type for n") }
}

///|
test "Parser triple dash types section" {
  let source = "---types---\nuser = User;\n---functions---\ngetUser = User;"
  let lexer = Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = Parser::new(tokens)
  let schema = parser.parse_schema()
  inspect(schema.types.length(), content="1")
  inspect(schema.functions.length(), content="1")
}
