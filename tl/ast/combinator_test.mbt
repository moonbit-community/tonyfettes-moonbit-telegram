///|
test "Conditional creation" {
  let cond = Conditional::{ var_name: LowerIdent::new(value="flags"), bit_index: Some(0) }
  inspect(cond.var_name.value, content="flags")
  inspect(cond.bit_index, content="Some(0)")
}

///|
test "NamedArg creation" {
  let arg = NamedArg::{
    name: LowerIdent::new(value="id"),
    conditional: None,
    bang: false,
    type_: Term::Ident(TypeIdent::{ ns: None, name: UpperIdent::new(value="long") }),
  }
  inspect(arg.name.value, content="id")
  assert_false(arg.bang)
}

///|
test "NamedArg with conditional" {
  let arg = NamedArg::{
    name: LowerIdent::new(value="first_name"),
    conditional: Some(Conditional::{ var_name: LowerIdent::new(value="flags"), bit_index: Some(0) }),
    bang: false,
    type_: Term::Ident(TypeIdent::{ ns: None, name: UpperIdent::new(value="string") }),
  }
  guard arg.conditional is Some(cond) else { fail("expected conditional") }
  inspect(cond.bit_index, content="Some(0)")
}

///|
test "OptionalArg creation" {
  let arg = OptionalArg::{
    names: [LowerIdent::new(value="t")],
    bang: false,
    type_: Expr::new(items=[
      Subexpr::Term(Term::Ident(TypeIdent::{ ns: None, name: UpperIdent::new(value="Type") })),
    ]),
  }
  inspect(arg.names.length(), content="1")
}

///|
test "MultiplicityArg creation" {
  let arg = MultiplicityArg::{
    name: None,
    count: Term::NatConst(4),
    args: [
      Arg::Anonymous({
        bang: false,
        type_: Term::Ident(TypeIdent::{ ns: None, name: UpperIdent::new(value="int") }),
      }),
    ],
  }
  guard arg.count is Term::NatConst(4) else { fail("expected Const(4)") }
}

///|
test "ResultType creation" {
  let result = ResultType::{
    type_ident: TypeIdent::{ ns: None, name: UpperIdent::new(value="User") },
    params: [],
  }
  inspect(result.type_ident.name.value, content="User")
}

///|
test "Combinator creation" {
  let span = Span::{
    start: Position::{ line: 1, column: 1, offset: 0 },
    end: Position::{ line: 1, column: 20, offset: 19 },
  }
  let combinator = Combinator::{
    ns: None,
    name: LowerIdent::new(value="user"),
    id: Some(ConstructorId::new(value=0xd23c81a3)),
    opt_args: [],
    args: [],
    result: ResultType::{
      type_ident: TypeIdent::{ ns: None, name: UpperIdent::new(value="User") },
      params: [],
    },
    span,
  }
  inspect(combinator.name.value, content="user")
  guard combinator.id is Some(_) else { fail("expected id") }
}

///|
test "FinalDecl variants" {
  let dummy_span = Span::new(
    start=Position::new(line=1, column=1, offset=0),
    end=Position::new(line=1, column=1, offset=0),
  )
  let new_decl = FinalDecl::New(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: UpperIdent::new(value="UserStatus") },
    span: dummy_span,
  })
  let final_decl = FinalDecl::Final(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: UpperIdent::new(value="UserStatus") },
    span: dummy_span,
  })
  let empty_decl = FinalDecl::Empty(FinalDeclData::{
    type_ident: TypeIdent::{ ns: None, name: UpperIdent::new(value="SomeType") },
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
