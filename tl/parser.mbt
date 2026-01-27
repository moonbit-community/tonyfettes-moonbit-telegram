///|
/// The parser state for parsing TL token streams.
struct Parser {
  tokens : Array[Token]
  mut pos : Int
  comments : Array[(Span, String)]
}

///|
/// Creates a new parser for the given token array.
pub fn Parser::new(tokens : Array[Token]) -> Parser {
  { tokens, pos: 0, comments: [] }
}

///|
/// Returns the current token without advancing.
fn Parser::current(self : Parser) -> Token {
  self.tokens[self.pos]
}

///|
/// Returns the kind of the current token.
fn Parser::peek(self : Parser) -> TokenKind {
  self.current().kind
}

///|
/// Returns true if we're at the end of file.
fn Parser::is_at_end(self : Parser) -> Bool {
  self.peek() is Eof
}

///|
/// Advances to the next token and returns the current token.
fn Parser::advance(self : Parser) -> Token {
  let t = self.current()
  if self.pos < self.tokens.length() - 1 {
    self.pos += 1
  }
  t
}

///|
/// Expects the current token to match the expected kind, advances and returns it.
fn Parser::expect(
  self : Parser,
  expected : TokenKind,
) -> Token raise TLParseError {
  let token = self.current()
  guard token.kind == expected else {
    raise TLParseError::UnexpectedToken(
      pos=token.span.start,
      expected=expected.to_string(),
      found=token.kind.to_string(),
    )
  }
  self.advance()
}

///|
/// Skips over any comment tokens, collecting them for preservation.
fn Parser::skip_comments(self : Parser) -> Unit {
  while not(self.is_at_end()) {
    match self.peek() {
      LineComment(s) | BlockComment(s) => {
        let token = self.advance()
        self.comments.push((token.span, s))
      }
      _ => break
    }
  }
}

///|
/// Entry point - parses a complete TL schema.
pub fn Parser::parse_schema(self : Parser) -> Schema raise TLParseError {
  let types : Array[Declaration] = []
  let functions : Array[Combinator] = []
  let mut in_functions = false
  while not(self.is_at_end()) {
    self.skip_comments()
    if self.is_at_end() {
      break
    }
    match self.peek() {
      TripleDash => {
        let _ = self.advance() // ---
        match self.peek() {
          Functions => {
            let _ = self.advance()
            in_functions = true
          }
          Types => {
            let _ = self.advance()
            in_functions = false
          }
          _ => () // Just --- separator
        }
        if self.peek() is TripleDash {
          let _ = self.advance()
           // trailing ---
        }
      }
      Final | New | Empty => {
        let decl = self.parse_final_decl()
        types.push(Declaration::Final(decl))
      }
      _ => {
        let combinator = self.parse_combinator()
        if in_functions {
          functions.push(combinator)
        } else {
          types.push(Declaration::Combinator(combinator))
        }
      }
    }
  }
  { types, functions, comments: self.comments }
}

///|
/// Parses a combinator: full-combinator-id { opt-args } { args } = result-type ;
fn Parser::parse_combinator(self : Parser) -> Combinator raise TLParseError {
  let start = self.current().span.start
  // Parse combinator name: lc-ident-ns or _
  let (ns, name) = self.parse_combinator_name()
  // Parse optional hex ID: #hexdigits
  let id : UInt? = if self.peek() is Hash {
    let _ = self.advance()
    match self.peek() {
      HexNumber(n) => {
        let _ = self.advance()
        Some(n)
      }
      _ => None
    }
  } else if self.peek() is HexNumber(n) {
    let _ = self.advance()
    Some(n)
  } else {
    None
  }
  // Parse optional args: { ... } { ... }
  let opt_args = self.parse_opt_args()
  // Parse regular args
  let args = self.parse_args()
  // Expect =
  let _ = self.expect(Equals)
  // Parse result type
  let result = self.parse_result_type()
  // Expect ;
  let end_token = self.expect(Semicolon)
  {
    ns,
    name,
    id,
    opt_args,
    args,
    result,
    span: Span::new(start~, end=end_token.span.end),
  }
}

///|
/// Parses a combinator name: lc-ident-ns (namespace.name) or _ or just lc-ident.
fn Parser::parse_combinator_name(
  self : Parser,
) -> (String?, String) raise TLParseError {
  match self.peek() {
    Underscore => {
      let _ = self.advance()
      (None, "_")
    }
    LowerIdent(name) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        match self.peek() {
          LowerIdent(n) => {
            let _ = self.advance()
            (Some(name), n)
          }
          Underscore => {
            let _ = self.advance()
            (Some(name), "_")
          }
          _ => {
            let token = self.current()
            raise TLParseError::UnexpectedToken(
              pos=token.span.start,
              expected="lower identifier after '.'",
              found=token.kind.to_string(),
            )
          }
        }
      } else {
        (None, name)
      }
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="combinator name (lower identifier or '_')",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses optional args: { var-ident { var-ident } : [!] type-expr }
fn Parser::parse_opt_args(
  self : Parser,
) -> Array[OptionalArg] raise TLParseError {
  let result : Array[OptionalArg] = []
  while self.peek() is LBrace {
    let _ = self.advance() // {
    let names : Array[String] = []
    // Collect names
    while true {
      match self.peek() {
        LowerIdent(s) | UpperIdent(s) => {
          let _ = self.advance()
          names.push(s)
        }
        _ => break
      }
    }
    let _ = self.expect(Colon)
    let bang = if self.peek() is Bang {
      let _ = self.advance()
      true
    } else {
      false
    }
    let type_ = self.parse_type_expr()
    let _ = self.expect(RBrace)
    result.push({ names, bang, type_ })
  }
  result
}

///|
/// Parses args until = is reached.
fn Parser::parse_args(self : Parser) -> Array[Arg] raise TLParseError {
  let result : Array[Arg] = []
  while not(self.peek() is Equals) && not(self.is_at_end()) {
    self.skip_comments()
    if self.peek() is Equals {
      break
    }
    result.push(self.parse_arg())
  }
  result
}

///|
/// Parses a single argument.
fn Parser::parse_arg(self : Parser) -> Arg raise TLParseError {
  match self.peek() {
    LParen => self.parse_grouped_arg()
    LBracket => {
      // Anonymous multiplicity: [ args ]
      let _ = self.advance() // [
      let inner_args = self.parse_bracket_args()
      let _ = self.expect(RBracket)
      Arg::Multiplicity({
        name: None,
        count: NatExpr::Const(1),
        args: inner_args,
      })
    }
    LowerIdent(_) | UpperIdent(_) =>
      // Could be name:type, name:cond?type, or just type
      if self.lookahead_is_named_arg() {
        self.parse_named_arg()
      } else {
        // Anonymous type
        let type_ = self.parse_type_expr()
        Arg::Anonymous(type_)
      }
    Bang => {
      let _ = self.advance()
      let type_ = self.parse_type_expr()
      Arg::Anonymous(TypeExpr::Bang(type_))
    }
    Percent => {
      let _ = self.advance()
      let type_ = self.parse_type_expr()
      Arg::Anonymous(TypeExpr::Percent(type_))
    }
    Hash => {
      // Bare # as anonymous type
      let _ = self.advance()
      Arg::Anonymous(TypeExpr::Nat)
    }
    Number(n) => {
      // Multiplicity: 4*[...]
      let _ = self.advance()
      let _ = self.expect(Star)
      let _ = self.expect(LBracket)
      let inner_args = self.parse_bracket_args()
      let _ = self.expect(RBracket)
      Arg::Multiplicity({
        name: None,
        count: NatExpr::Const(n),
        args: inner_args,
      })
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="argument",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Looks ahead to determine if this is a named arg (has : or . or ? after ident).
fn Parser::lookahead_is_named_arg(self : Parser) -> Bool {
  let saved = self.pos
  // Skip first ident
  let _ = self.advance()
  let result = match self.peek() {
    Colon | Dot | Question => true
    _ => false
  }
  self.pos = saved
  result
}

///|
/// Parses a named argument: name:type or name:cond?type or name.nat:type.
fn Parser::parse_named_arg(self : Parser) -> Arg raise TLParseError {
  let name = match self.peek() {
    LowerIdent(s) | UpperIdent(s) => {
      let _ = self.advance()
      s
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="identifier for named arg",
        found=token.kind.to_string(),
      )
    }
  }
  // Check for conditional: name.N? or just name?
  let conditional : Conditional? = if self.peek() is Dot {
    let _ = self.advance() // .
    // Parse bit index
    match self.peek() {
      Number(bit_idx) => {
        let _ = self.advance()
        let _ = self.expect(Question)
        Some({ var_name: name, bit_index: Some(bit_idx) })
      }
      _ => {
        let token = self.current()
        raise TLParseError::UnexpectedToken(
          pos=token.span.start,
          expected="bit index (number) after '.'",
          found=token.kind.to_string(),
        )
      }
    }
  } else if self.peek() is Question {
    let _ = self.advance()
    Some({ var_name: name, bit_index: None })
  } else {
    None
  }
  // Now we need to determine: if we consumed as conditional, the name is the var_name
  // and we need to read the actual field name, or if no conditional, the name is the field name
  if conditional is Some(cond) {
    // The "name" was actually the conditional var; now parse actual field name
    let actual_name = match self.peek() {
      LowerIdent(s) | UpperIdent(s) => {
        let _ = self.advance()
        s
      }
      _ => {
        let token = self.current()
        raise TLParseError::UnexpectedToken(
          pos=token.span.start,
          expected="field name after conditional",
          found=token.kind.to_string(),
        )
      }
    }
    let _ = self.expect(Colon)
    let bang = if self.peek() is Bang {
      let _ = self.advance()
      true
    } else {
      false
    }
    let type_ = self.parse_type_expr()
    Arg::Named({ name: actual_name, conditional: Some(cond), bang, type_ })
  } else {
    // name is the field name, check for :
    let _ = self.expect(Colon)
    // Check if there's a conditional after the colon (flags.N?)
    let cond2 : Conditional? = if self.peek() is LowerIdent(var_name) {
      let saved = self.pos
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        match self.peek() {
          Number(bit_idx) => {
            let _ = self.advance()
            if self.peek() is Question {
              let _ = self.advance()
              Some({ var_name, bit_index: Some(bit_idx) })
            } else {
              // Not a conditional, restore
              self.pos = saved
              None
            }
          }
          _ => {
            // Not a conditional, restore
            self.pos = saved
            None
          }
        }
      } else if self.peek() is Question {
        let _ = self.advance()
        Some({ var_name, bit_index: None })
      } else {
        // Just a type, restore
        self.pos = saved
        None
      }
    } else {
      None
    }
    let bang = if self.peek() is Bang {
      let _ = self.advance()
      true
    } else {
      false
    }
    let type_ = self.parse_type_expr()
    Arg::Named({ name, conditional: cond2, bang, type_ })
  }
}

///|
/// Parses a grouped argument: (x y : Type).
fn Parser::parse_grouped_arg(self : Parser) -> Arg raise TLParseError {
  let _ = self.advance() // (
  let names : Array[String] = []
  // Collect names until :
  while not(self.peek() is Colon) && not(self.is_at_end()) {
    match self.peek() {
      LowerIdent(s) | UpperIdent(s) => {
        let _ = self.advance()
        names.push(s)
      }
      _ => break
    }
  }
  let _ = self.expect(Colon)
  let bang = if self.peek() is Bang {
    let _ = self.advance()
    true
  } else {
    false
  }
  let type_ = self.parse_type_expr()
  let _ = self.expect(RParen)
  Arg::Grouped({ names, bang, type_ })
}

///|
/// Parses args inside brackets for multiplicity.
fn Parser::parse_bracket_args(self : Parser) -> Array[Arg] raise TLParseError {
  let result : Array[Arg] = []
  while not(self.peek() is RBracket) && not(self.is_at_end()) {
    self.skip_comments()
    if self.peek() is RBracket {
      break
    }
    result.push(self.parse_arg())
  }
  result
}

///|
/// Parses a type expression.
fn Parser::parse_type_expr(self : Parser) -> TypeExpr raise TLParseError {
  match self.peek() {
    Bang => {
      let _ = self.advance()
      TypeExpr::Bang(self.parse_type_expr())
    }
    Percent => {
      let _ = self.advance()
      TypeExpr::Percent(self.parse_type_expr())
    }
    Hash => {
      let _ = self.advance()
      TypeExpr::Nat
    }
    LowerIdent(name) => {
      let _ = self.advance()
      // Check for namespace: name.Name
      if self.peek() is Dot {
        let _ = self.advance()
        let type_name = self.parse_ident_name()
        let ident = TypeIdent::new(name=type_name, ns=name)
        self.parse_type_apply(ident)
      } else {
        // Could be variable
        TypeExpr::Var(name)
      }
    }
    UpperIdent(name) => {
      let _ = self.advance()
      let ident = TypeIdent::simple(name)
      self.parse_type_apply(ident)
    }
    LParen => {
      let _ = self.advance()
      let expr = self.parse_type_expr()
      let _ = self.expect(RParen)
      expr
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="type expression",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses an identifier name (lower or upper).
fn Parser::parse_ident_name(self : Parser) -> String raise TLParseError {
  match self.peek() {
    LowerIdent(s) | UpperIdent(s) => {
      let _ = self.advance()
      s
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="identifier",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses type application if present: Type<...> or just Type.
fn Parser::parse_type_apply(
  self : Parser,
  ident : TypeIdent,
) -> TypeExpr raise TLParseError {
  if self.peek() is LAngle {
    let _ = self.advance() // <
    let params : Array[TypeExpr] = []
    params.push(self.parse_type_expr())
    while self.peek() is Comma {
      let _ = self.advance()
      params.push(self.parse_type_expr())
    }
    let _ = self.expect(RAngle)
    TypeExpr::Apply(ident, params)
  } else {
    TypeExpr::Ident(ident)
  }
}

///|
/// Parses a result type: type-ident { params } or type-ident < params >.
fn Parser::parse_result_type(self : Parser) -> ResultType raise TLParseError {
  let (ns, name) = self.parse_type_ident_name()
  let type_ident = TypeIdent::new(name~, ns?)
  let params : Array[Expr] = []
  if self.peek() is LAngle {
    let _ = self.advance()
    params.push(self.parse_expr())
    while self.peek() is Comma {
      let _ = self.advance()
      params.push(self.parse_expr())
    }
    let _ = self.expect(RAngle)

  } else {
    // Parse trailing subexprs (space separated until ;)
    while not(self.peek() is Semicolon) && not(self.is_at_end()) {
      params.push(self.parse_expr())
    }
  }
  { type_ident, params }
}

///|
/// Parses a type identifier name with optional namespace: ns.Name or Name.
fn Parser::parse_type_ident_name(
  self : Parser,
) -> (String?, String) raise TLParseError {
  match self.peek() {
    LowerIdent(ns) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        let name = self.parse_ident_name()
        (Some(ns), name)
      } else {
        // It's actually a bare type name, lowercase allowed in result
        (None, ns)
      }
    }
    UpperIdent(name) => {
      let _ = self.advance()
      (None, name)
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="type identifier",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses an expression (type or nat).
fn Parser::parse_expr(self : Parser) -> Expr raise TLParseError {
  match self.peek() {
    Number(n) => {
      let _ = self.advance()
      // Check for + for nat arithmetic
      if self.peek() is Plus {
        let _ = self.advance()
        let right = self.parse_nat_expr()
        Expr::Nat(NatExpr::Add(NatExpr::Const(n), right))
      } else {
        Expr::Nat(NatExpr::Const(n))
      }
    }
    LowerIdent(name) => {
      // Could be nat var or type var
      let saved = self.pos
      let _ = self.advance()
      if self.peek() is Plus {
        let _ = self.advance()
        let right = self.parse_nat_expr()
        Expr::Nat(NatExpr::Add(NatExpr::Var(name), right))
      } else if self.peek() is Dot {
        // Namespace, restore and parse as type
        self.pos = saved
        Expr::Type(self.parse_type_expr())
      } else {
        // Ambiguous - could be nat var or type var
        // In result context, assume type var
        Expr::Type(TypeExpr::Var(name))
      }
    }
    UpperIdent(_) | Bang | Percent | Hash | LParen =>
      Expr::Type(self.parse_type_expr())
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="expression",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a nat expression: n or n+m.
fn Parser::parse_nat_expr(self : Parser) -> NatExpr raise TLParseError {
  match self.peek() {
    Number(n) => {
      let _ = self.advance()
      if self.peek() is Plus {
        let _ = self.advance()
        let right = self.parse_nat_expr()
        NatExpr::Add(NatExpr::Const(n), right)
      } else {
        NatExpr::Const(n)
      }
    }
    LowerIdent(name) => {
      let _ = self.advance()
      if self.peek() is Plus {
        let _ = self.advance()
        let right = self.parse_nat_expr()
        NatExpr::Add(NatExpr::Var(name), right)
      } else {
        NatExpr::Var(name)
      }
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="nat expression",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a final declaration: New/Final/Empty TypeIdent ;
fn Parser::parse_final_decl(self : Parser) -> FinalDecl raise TLParseError {
  match self.peek() {
    New => {
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let _ = self.expect(Semicolon)
      FinalDecl::New(ident)
    }
    Final => {
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let _ = self.expect(Semicolon)
      FinalDecl::Final(ident)
    }
    Empty => {
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let _ = self.expect(Semicolon)
      FinalDecl::Empty(ident)
    }
    _ => {
      let token = self.current()
      raise TLParseError::UnexpectedToken(
        pos=token.span.start,
        expected="final declaration (New, Final, or Empty)",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a type identifier: ns.Name or Name.
fn Parser::parse_type_ident(self : Parser) -> TypeIdent raise TLParseError {
  let (ns, name) = self.parse_type_ident_name()
  TypeIdent::new(name~, ns?)
}
