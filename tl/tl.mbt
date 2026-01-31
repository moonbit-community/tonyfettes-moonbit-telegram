///|
/// Re-export core types from subpackages for convenience.
/// Users can import just `tl` and access all types.

// Re-export AST types
pub using @ast {
  type Position,
  type Span,
  type TypeIdent,
  type Term,
  type Subexpr,
  type Expr,
  type Conditional,
  type NamedArg,
  type OptionalArg,
  type MultiplicityArg,
  type GroupedArg,
  type AnonymousArg,
  type Arg,
  type ResultType,
  type Combinator,
  type FinalDecl,
  type Declaration,
  type Schema,
}

// Re-export lexer types

///|
pub using @lexer {type TokenKind, type Token, type Lexer, type LexError}

// Re-export parser types

///|
pub using @parser {type Parser, type ParseError}

// Re-export typer types and functions

///|
pub using @typer {
  type TLTypeError,
  type ResolvedType,
  type SymbolTable,
  crc32,
  normalize_combinator,
}

///|
/// Parses a TL schema from source text.
///
/// Example:
/// ```
/// let schema = @tl.parse(source="user id:long = User;")
/// ```
pub fn parse(source~ : String) -> @ast.Schema raise {
  let lexer = @lexer.Lexer::new(source~)
  let tokens = lexer.tokenize()
  let parser = @parser.Parser::new(tokens)
  parser.parse_schema()
}

///|
/// Type checks a TL schema and builds a symbol table.
///
/// Example:
/// ```
/// let schema = @tl.parse(source="user id:long = User;")
/// let table = @tl.type_schema(schema)
/// ```
pub fn type_schema(
  schema : @ast.Schema,
) -> @typer.SymbolTable raise @typer.TLTypeError {
  @typer.type_schema(schema)
}

///|
/// Pretty-prints a Schema back to TL format.
pub fn schema_to_string(schema : @ast.Schema) -> String {
  let sb = StringBuilder::new()

  // Print type declarations
  for decl in schema.types {
    match decl {
      @ast.Declaration::Combinator(c) => {
        sb.write_string(combinator_to_string(c))
        sb.write_char('\n')
      }
      @ast.Declaration::Final(f) => {
        sb.write_string(final_decl_to_string(f))
        sb.write_char('\n')
      }
    }
  }

  // Print functions section if any
  if not(schema.functions.is_empty()) {
    sb.write_string("---functions---\n")
    for f in schema.functions {
      sb.write_string(combinator_to_string(f))
      sb.write_char('\n')
    }
  }
  sb.to_string()
}

///|
fn combinator_to_string(c : @ast.Combinator) -> String {
  let sb = StringBuilder::new()

  // Namespace.name
  if c.ns is Some(ns) {
    sb.write_string(ns.value)
    sb.write_char('.')
  }
  sb.write_string(c.name.value)

  // Optional hex ID
  if c.id is Some(id) {
    sb.write_char('#')
    sb.write_string(uint_to_hex(id.value))
  }

  // Optional args
  for opt in c.opt_args {
    sb.write_string(" {")
    sb.write_string(opt.names.map(fn(n) { n.value }).join(" "))
    sb.write_char(':')
    if opt.bang {
      sb.write_char('!')
    }
    sb.write_string(expr_to_string(opt.type_))
    sb.write_char('}')
  }

  // Regular args
  for arg in c.args {
    sb.write_char(' ')
    sb.write_string(arg_to_string(arg))
  }

  // = result
  sb.write_string(" = ")
  sb.write_string(result_type_to_string(c.result))
  sb.write_char(';')
  sb.to_string()
}

///|
fn uint_to_hex(n : UInt) -> String {
  if n == 0 {
    return "0"
  }
  let digits = "0123456789abcdef"
  let sb = StringBuilder::new()
  let mut val = n
  while val > 0 {
    let digit = (val % 16).reinterpret_as_int()
    guard digits.get_char(digit) is Some(ch) else { break }
    sb.write_char(ch)
    val = val / 16
  }
  // Reverse the string
  let s = sb.to_string()
  let len = s.length()
  let result = StringBuilder::new()
  for i = len - 1; i >= 0; i = i - 1 {
    guard s.get_char(i) is Some(ch) else { break }
    result.write_char(ch)
  }
  result.to_string()
}

///|

///|
fn type_ident_to_string(ident : @ast.TypeIdent) -> String {
  if ident.ns is Some(ns) {
    ns.value + "." + ident.name.value
  } else {
    ident.name.value
  }
}

///|
fn arg_to_string(arg : @ast.Arg) -> String {
  match arg {
    @ast.Arg::Named(named) => named_arg_to_string(named)
    @ast.Arg::Multiplicity(mult) => multiplicity_arg_to_string(mult)
    @ast.Arg::Grouped(grouped) => grouped_arg_to_string(grouped)
    @ast.Arg::Anonymous(anon) => {
      let prefix = if anon.bang { "!" } else { "" }
      prefix + term_to_string(anon.type_)
    }
  }
}

///|
fn named_arg_to_string(arg : @ast.NamedArg) -> String {
  let sb = StringBuilder::new()
  sb.write_string(arg.name.value)
  sb.write_char(':')
  if arg.conditional is Some(cond) {
    sb.write_string(cond.var_name.value)
    if cond.bit_index is Some(idx) {
      sb.write_char('.')
      sb.write_string(idx.to_string())
    }
    sb.write_char('?')
  }
  if arg.bang {
    sb.write_char('!')
  }
  sb.write_string(term_to_string(arg.type_))
  sb.to_string()
}

///|
fn multiplicity_arg_to_string(mult : @ast.MultiplicityArg) -> String {
  let sb = StringBuilder::new()
  if mult.name is Some(name) {
    sb.write_string(name.value)
    sb.write_char(':')
  }
  sb.write_string(term_to_string(mult.count))
  sb.write_string("*[")
  for i, a in mult.args {
    if i > 0 {
      sb.write_char(' ')
    }
    sb.write_string(arg_to_string(a))
  }
  sb.write_char(']')
  sb.to_string()
}

///|
fn grouped_arg_to_string(grouped : @ast.GroupedArg) -> String {
  let sb = StringBuilder::new()
  sb.write_char('(')
  sb.write_string(grouped.names.map(fn(n) { n.value }).join(" "))
  sb.write_char(':')
  if grouped.bang {
    sb.write_char('!')
  }
  sb.write_string(term_to_string(grouped.type_))
  sb.write_char(')')
  sb.to_string()
}

///|
fn term_to_string(term : @ast.Term) -> String {
  match term {
    @ast.Term::Paren(expr) => "(" + expr_to_string(expr) + ")"
    @ast.Term::Ident(ident) => type_ident_to_string(ident)
    @ast.Term::Var(name) => name.value
    @ast.Term::NatConst(n) => n.to_string()
    @ast.Term::Percent(inner) => "%" + term_to_string(inner)
    @ast.Term::Apply(ident, params) => {
      let sb = StringBuilder::new()
      sb.write_string(type_ident_to_string(ident))
      sb.write_char('<')
      for i, p in params {
        if i > 0 {
          sb.write_string(", ")
        }
        sb.write_string(expr_to_string(p))
      }
      sb.write_char('>')
      sb.to_string()
    }
  }
}

///|
fn subexpr_to_string(expr : @ast.Subexpr) -> String {
  match expr {
    @ast.Subexpr::Term(term) => term_to_string(term)
    @ast.Subexpr::AddLeft(n, right) =>
      n.to_string() + "+" + subexpr_to_string(right)
    @ast.Subexpr::AddRight(left, n) =>
      subexpr_to_string(left) + "+" + n.to_string()
  }
}

///|
fn result_type_to_string(result : @ast.ResultType) -> String {
  let sb = StringBuilder::new()
  sb.write_string(type_ident_to_string(result.type_ident))
  for param in result.params {
    sb.write_char(' ')
    sb.write_string(subexpr_to_string(param))
  }
  sb.to_string()
}

///|
fn expr_to_string(expr : @ast.Expr) -> String {
  let sb = StringBuilder::new()
  for i, item in expr.items {
    if i > 0 {
      sb.write_char(' ')
    }
    sb.write_string(subexpr_to_string(item))
  }
  sb.to_string()
}

///|
fn final_decl_to_string(decl : @ast.FinalDecl) -> String {
  match decl {
    @ast.FinalDecl::New(data) =>
      "New " + type_ident_to_string(data.type_ident) + ";"
    @ast.FinalDecl::Final(data) =>
      "Final " + type_ident_to_string(data.type_ident) + ";"
    @ast.FinalDecl::Empty(data) =>
      "Empty " + type_ident_to_string(data.type_ident) + ";"
  }
}
