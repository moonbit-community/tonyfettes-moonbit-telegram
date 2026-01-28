///|
test "Conditional creation" {
  let cond = Conditional::{ var_name: "flags", bit_index: Some(0) }
  inspect(cond.var_name, content="flags")
  inspect(cond.bit_index, content="Some(0)")
}

///|
test "NamedArg creation" {
  let arg = NamedArg::{
    name: "id",
    conditional: None,
    bang: false,
    type_: TypeExpr::Ident(TypeIdent::{ ns: None, name: "long" }),
  }
  inspect(arg.name, content="id")
  assert_false(arg.bang)
}

///|
test "NamedArg with conditional" {
  let arg = NamedArg::{
    name: "first_name",
    conditional: Some(Conditional::{ var_name: "flags", bit_index: Some(0) }),
    bang: false,
    type_: TypeExpr::Ident(TypeIdent::{ ns: None, name: "string" }),
  }
  guard arg.conditional is Some(cond) else { fail("expected conditional") }
  inspect(cond.bit_index, content="Some(0)")
}

///|
test "OptionalArg creation" {
  let arg = OptionalArg::{
    names: ["t"],
    bang: false,
    type_: TypeExpr::Ident(TypeIdent::{ ns: None, name: "Type" }),
  }
  inspect(arg.names.length(), content="1")
}

///|
test "MultiplicityArg creation" {
  let arg = MultiplicityArg::{
    name: None,
    count: NatExpr::Const(4),
    args: [
      Arg::Anonymous(TypeExpr::Ident(TypeIdent::{ ns: None, name: "int" })),
    ],
  }
  guard arg.count is NatExpr::Const(4) else { fail("expected Const(4)") }
}

///|
test "ResultType creation" {
  let result = ResultType::{
    type_ident: TypeIdent::{ ns: None, name: "User" },
    params: [],
  }
  inspect(result.type_ident.name, content="User")
}

///|
test "Combinator creation" {
  let span = Span::{
    start: Position::{ line: 1, column: 1, offset: 0 },
    end: Position::{ line: 1, column: 20, offset: 19 },
  }
  let combinator = Combinator::{
    ns: None,
    name: "user",
    id: Some(0xd23c81a3),
    opt_args: [],
    args: [],
    result: ResultType::{
      type_ident: TypeIdent::{ ns: None, name: "User" },
      params: [],
    },
    span,
  }
  inspect(combinator.name, content="user")
  guard combinator.id is Some(_) else { fail("expected id") }
}

///|
test "FinalDecl variants" {
  let dummy_span = Span::new(
    start=Position::new(line=1, column=1, offset=0),
    end=Position::new(line=1, column=1, offset=0),
  )
  let new_decl = FinalDecl::New(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: "UserStatus" },
    span: dummy_span,
  })
  let final_decl = FinalDecl::Final(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: "UserStatus" },
    span: dummy_span,
  })
  let empty_decl = FinalDecl::Empty(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: "SomeType" },
    span: dummy_span,
  })
  guard new_decl is New(_) else { fail("expected New") }
  guard final_decl is Final(_) else { fail("expected Final") }
  guard empty_decl is Empty(_) else { fail("expected Empty") }
}

///|
test "Schema creation" {
  let schema = Schema::new()
  inspect(schema.types.length(), content="0")
  inspect(schema.functions.length(), content="0")
}
