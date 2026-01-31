///|
/// Errors that can occur during TL parsing.
pub(all) suberror ParseError {
  UnexpectedToken(pos~ : @ast.Position, expected~ : String, found~ : String)
  UnexpectedEof(pos~ : @ast.Position)
} derive(Show, Eq)

///|
/// The parser state for parsing TL token streams.
pub(all) struct Parser {
  tokens : Array[@lexer.Token]
  mut pos : Int
  comments : Array[(@ast.Span, String)]
}

///|
/// Creates a new parser for the given token array.
pub fn Parser::new(tokens : Array[@lexer.Token]) -> Parser {
  { tokens, pos: 0, comments: [] }
}

///|
/// Returns the current token without advancing.
fn Parser::current(self : Parser) -> @lexer.Token {
  self.tokens[self.pos]
}

///|
/// Returns the kind of the current token.
fn Parser::peek(self : Parser) -> @lexer.TokenKind {
  self.current().kind
}

///|
/// Returns true if we're at the end of file.
fn Parser::is_at_end(self : Parser) -> Bool {
  self.peek() is Eof
}

///|
/// Advances to the next token and returns the current token.
fn Parser::advance(self : Parser) -> @lexer.Token {
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
  expected : @lexer.TokenKind,
) -> @lexer.Token raise ParseError {
  let token = self.current()
  guard token.kind == expected else {
    raise ParseError::UnexpectedToken(
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
pub fn Parser::parse_schema(self : Parser) -> @ast.Schema raise ParseError {
  let types : Array[@ast.Declaration] = []
  let functions : Array[@ast.Combinator] = []
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
        types.push(@ast.Declaration::Final(decl))
      }
      _ => {
        let combinator = self.parse_combinator()
        if in_functions {
          functions.push(combinator)
        } else {
          types.push(@ast.Declaration::Combinator(combinator))
        }
      }
    }
  }
  { types, functions, comments: self.comments }
}

///|
/// Parses a combinator: full-combinator-id { opt-args } { args } = result-type ;
fn Parser::parse_combinator(self : Parser) -> @ast.Combinator raise ParseError {
  let start = self.current().span.start
  // Parse combinator name: lc-ident-ns or _
  let (ns, name) = self.parse_combinator_name()
  let name_end = self.tokens[self.pos - 1].span.end
  // Parse optional hex ID: #hexdigits
  let id : @ast.ConstructorId? = if self.peek() is Hash &&
    self.current().span.start.offset == name_end.offset {
    let _ = self.advance()
    match self.peek() {
      HexNumber(n) => {
        let _ = self.advance()
        Some(@ast.ConstructorId::new(value=n))
      }
      _ => None
    }
  } else if self.peek() is HexNumber(n) &&
    self.current().span.start.offset == name_end.offset {
    let _ = self.advance()
    Some(@ast.ConstructorId::new(value=n))
  } else {
    None
  }
  // Handle `?` as a marker for built-in types with no fixed constructor ID
  // e.g., `int ? = Int;`
  if self.peek() is Question {
    let _ = self.advance()
    // Expect =
    let _ = self.expect(Equals)
    // Parse result type
    let result = self.parse_result_type()
    // Expect ;
    let end_token = self.expect(Semicolon)
    return {
      ns,
      name,
      id,
      opt_args: [],
      args: [],
      result,
      span: @ast.Span::new(start~, end=end_token.span.end),
    }
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
    span: @ast.Span::new(start~, end=end_token.span.end),
  }
}

///|
/// Parses a combinator name: lc-ident-ns (namespace.name) or _ or just lc-ident.
fn Parser::parse_combinator_name(
  self : Parser,
) -> (@ast.LowerIdent?, @ast.LowerIdent) raise ParseError {
  match self.peek() {
    Underscore => {
      let _ = self.advance()
      (None, @ast.LowerIdent::new(value="_"))
    }
    LowerIdent(name) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        match self.peek() {
          LowerIdent(n) => {
            let _ = self.advance()
            (Some(@ast.LowerIdent::new(value=name)), @ast.LowerIdent::new(value=n))
          }
          Underscore => {
            let _ = self.advance()
            (Some(@ast.LowerIdent::new(value=name)), @ast.LowerIdent::new(value="_"))
          }
          _ => {
            let token = self.current()
            raise ParseError::UnexpectedToken(
              pos=token.span.start,
              expected="lower identifier after '.'",
              found=token.kind.to_string(),
            )
          }
        }
      } else {
        (None, @ast.LowerIdent::new(value=name))
      }
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
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
) -> Array[@ast.OptionalArg] raise ParseError {
  let result : Array[@ast.OptionalArg] = []
  while self.peek() is LBrace {
    let _ = self.advance() // {
    let names : Array[@ast.LowerIdent] = []
    // Collect names
    while true {
      match self.peek() {
        LowerIdent(s) | UpperIdent(s) => {
          let _ = self.advance()
          names.push(@ast.LowerIdent::new(value=s))
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
    let type_ = self.parse_expr_until([RBrace])
    if type_.items.length() == 0 {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="type expression",
        found=token.kind.to_string(),
      )
    }
    let _ = self.expect(RBrace)
    result.push({ names, bang, type_ })
  }
  result
}

///|
/// Parses args until = is reached.
fn Parser::parse_args(self : Parser) -> Array[@ast.Arg] raise ParseError {
  let result : Array[@ast.Arg] = []
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
fn Parser::parse_arg(self : Parser) -> @ast.Arg raise ParseError {
  match self.peek() {
    LParen if self.lookahead_is_grouped_arg() => self.parse_grouped_arg()
    LBracket => {
      // Anonymous multiplicity: [ args ]
      let _ = self.advance() // [
      let inner_args = self.parse_bracket_args()
      let _ = self.expect(RBracket)
      @ast.Arg::Multiplicity({
        name: None,
        count: @ast.Term::NatConst(1),
        args: inner_args,
      })
    }
    _ => {
      if self.lookahead_is_named_arg() {
        let parsed = self.parse_named_arg()
        match parsed {
          @ast.Arg::Named(named) if named.conditional is None &&
            not(named.bang) &&
            self.peek() is Star => {
            let _ = self.advance()
            let _ = self.expect(LBracket)
            let inner_args = self.parse_bracket_args()
            let _ = self.expect(RBracket)
            return @ast.Arg::Multiplicity({
              name: Some(named.name),
              count: named.type_,
              args: inner_args,
            })
          }
          _ => return parsed
        }
      }
      let bang = if self.peek() is Bang {
        let _ = self.advance()
        true
      } else {
        false
      }
      let term = self.parse_term()
      if not(bang) && self.peek() is Star {
        let _ = self.advance()
        let _ = self.expect(LBracket)
        let inner_args = self.parse_bracket_args()
        let _ = self.expect(RBracket)
        @ast.Arg::Multiplicity({ name: None, count: term, args: inner_args })
      } else {
        @ast.Arg::Anonymous({ bang, type_: term })
      }
    }
  }
}

///|
/// Looks ahead to determine if this is a named arg (name: or flags.? forms).
fn Parser::lookahead_is_named_arg(self : Parser) -> Bool {
  let saved = self.pos
  // Only identifiers can start named args
  match self.peek() {
    LowerIdent(_) | UpperIdent(_) | Types | Functions => ()
    _ => return false
  }
  let _ = self.advance()
  let result = match self.peek() {
    Colon | Question => true
    Dot => {
      let _ = self.advance()
      if self.peek() is Number(_) {
        let _ = self.advance()
        self.peek() is Question
      } else {
        false
      }
    }
    _ => false
  }
  self.pos = saved
  result
}

///|
/// Looks ahead to determine if this is a grouped arg `(x y : Type)`.
fn Parser::lookahead_is_grouped_arg(self : Parser) -> Bool {
  let saved = self.pos
  let mut depth = 0
  let mut found_colon = false
  let mut i = self.pos
  while i < self.tokens.length() {
    match self.tokens[i].kind {
      LParen => depth += 1
      RParen => {
        if depth == 1 {
          self.pos = saved
          return found_colon
        }
        depth -= 1
      }
      Colon => if depth == 1 { found_colon = true }
      _ => ()
    }
    i += 1
  }
  self.pos = saved
  false
}

///|
/// Parses a named argument: name:type or name:cond?type or name.nat:type.
fn Parser::parse_named_arg(self : Parser) -> @ast.Arg raise ParseError {
  let name = match self.peek() {
    LowerIdent(s) | UpperIdent(s) => {
      let _ = self.advance()
      s
    }
    // Handle keywords that can also be field names
    Types => {
      let _ = self.advance()
      "types"
    }
    Functions => {
      let _ = self.advance()
      "functions"
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="identifier for named arg",
        found=token.kind.to_string(),
      )
    }
  }
  // Check for conditional: name.N? or just name?
  let conditional : @ast.Conditional? = if self.peek() is Dot {
    let _ = self.advance() // .
    // Parse bit index
    match self.peek() {
      Number(bit_idx) => {
        let _ = self.advance()
        let _ = self.expect(Question)
        Some({ var_name: @ast.LowerIdent::new(value=name), bit_index: Some(bit_idx) })
      }
      _ => {
        let token = self.current()
        raise ParseError::UnexpectedToken(
          pos=token.span.start,
          expected="bit index (number) after '.'",
          found=token.kind.to_string(),
        )
      }
    }
  } else if self.peek() is Question {
    let _ = self.advance()
    Some({ var_name: @ast.LowerIdent::new(value=name), bit_index: None })
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
        raise ParseError::UnexpectedToken(
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
    let type_ = self.parse_term()
    @ast.Arg::Named({ name: @ast.LowerIdent::new(value=actual_name), conditional: Some(cond), bang, type_ })
  } else {
    // name is the field name, check for :
    let _ = self.expect(Colon)
    // Check if there's a conditional after the colon (flags.N?)
    let cond2 : @ast.Conditional? = if self.peek() is LowerIdent(var_name) {
      let saved = self.pos
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        match self.peek() {
          Number(bit_idx) => {
            let _ = self.advance()
            if self.peek() is Question {
              let _ = self.advance()
              Some({ var_name: @ast.LowerIdent::new(value=var_name), bit_index: Some(bit_idx) })
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
        Some({ var_name: @ast.LowerIdent::new(value=var_name), bit_index: None })
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
    let type_ = self.parse_term()
    @ast.Arg::Named({ name: @ast.LowerIdent::new(value=name), conditional: cond2, bang, type_ })
  }
}

///|
/// Parses a grouped argument: (x y : Type).
fn Parser::parse_grouped_arg(self : Parser) -> @ast.Arg raise ParseError {
  let _ = self.advance() // (
  let names : Array[@ast.LowerIdent] = []
  // Collect names until :
  while not(self.peek() is Colon) && not(self.is_at_end()) {
    match self.peek() {
      LowerIdent(s) | UpperIdent(s) => {
        let _ = self.advance()
        names.push(@ast.LowerIdent::new(value=s))
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
  let type_ = self.parse_term()
  let _ = self.expect(RParen)
  @ast.Arg::Grouped({ names, bang, type_ })
}

///|
/// Parses args inside brackets for multiplicity.
fn Parser::parse_bracket_args(
  self : Parser,
) -> Array[@ast.Arg] raise ParseError {
  let result : Array[@ast.Arg] = []
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
/// Parses an identifier name (lower or upper).
fn Parser::parse_ident_name(self : Parser) -> String raise ParseError {
  match self.peek() {
    LowerIdent(s) | UpperIdent(s) => {
      let _ = self.advance()
      s
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="identifier",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a term.
fn Parser::parse_term(self : Parser) -> @ast.Term raise ParseError {
  match self.peek() {
    LParen => {
      let _ = self.advance()
      let expr = self.parse_expr_until([RParen])
      let _ = self.expect(RParen)
      @ast.Term::Paren(expr)
    }
    Percent => {
      let _ = self.advance()
      @ast.Term::Percent(self.parse_term())
    }
    Hash => {
      let _ = self.advance()
      @ast.Term::Ident(@ast.TypeIdent::simple(@ast.UpperIdent::new(value="#")))
    }
    Number(n) => {
      let _ = self.advance()
      @ast.Term::NatConst(n)
    }
    LowerIdent(name) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        let type_name = self.parse_ident_name()
        let ident = @ast.TypeIdent::new(name=@ast.UpperIdent::new(value=type_name), ns=@ast.LowerIdent::new(value=name))
        self.parse_term_apply(ident)
      } else if self.peek() is LAngle {
        let ident = @ast.TypeIdent::simple(@ast.UpperIdent::new(value=name))
        self.parse_term_apply(ident)
      } else {
        @ast.Term::Var(@ast.LowerIdent::new(value=name))
      }
    }
    UpperIdent(name) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        let type_name = self.parse_ident_name()
        let ident = @ast.TypeIdent::new(name=@ast.UpperIdent::new(value=type_name), ns=@ast.LowerIdent::new(value=name))
        self.parse_term_apply(ident)
      } else if self.peek() is LAngle {
        let ident = @ast.TypeIdent::simple(@ast.UpperIdent::new(value=name))
        self.parse_term_apply(ident)
      } else {
        @ast.Term::Ident(@ast.TypeIdent::simple(@ast.UpperIdent::new(value=name)))
      }
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="term",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses type application if present: Type<...> or just Type.
fn Parser::parse_term_apply(
  self : Parser,
  ident : @ast.TypeIdent,
) -> @ast.Term raise ParseError {
  if self.peek() is LAngle {
    let _ = self.advance() // <
    let params : Array[@ast.Expr] = []
    let first = self.parse_expr_until([Comma, RAngle])
    if first.items.length() == 0 {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="expression",
        found=token.kind.to_string(),
      )
    }
    params.push(first)
    while self.peek() is Comma {
      let _ = self.advance()
      let expr = self.parse_expr_until([Comma, RAngle])
      if expr.items.length() == 0 {
        let token = self.current()
        raise ParseError::UnexpectedToken(
          pos=token.span.start,
          expected="expression",
          found=token.kind.to_string(),
        )
      }
      params.push(expr)
    }
    let _ = self.expect(RAngle)
    @ast.Term::Apply(ident, params)
  } else {
    @ast.Term::Ident(ident)
  }
}

///|
/// Parses a subexpression (term or nat-const addition).
fn Parser::parse_subexpr(self : Parser) -> @ast.Subexpr raise ParseError {
  if self.peek() is Number(n) && self.peek_next_is_plus() {
    let _ = self.advance()
    let _ = self.expect(Plus)
    let right = self.parse_subexpr()
    return @ast.Subexpr::AddLeft(n, right)
  }
  let mut result : @ast.Subexpr = @ast.Subexpr::Term(self.parse_term())
  while self.peek() is Plus {
    let _ = self.advance()
    match self.peek() {
      Number(n) => {
        let _ = self.advance()
        result = @ast.Subexpr::AddRight(result, n)
      }
      _ => {
        let token = self.current()
        raise ParseError::UnexpectedToken(
          pos=token.span.start,
          expected="nat constant after '+'",
          found=token.kind.to_string(),
        )
      }
    }
  }
  result
}

///|
/// Parses an expression until a stop token is reached.
fn Parser::parse_expr_until(
  self : Parser,
  stops : Array[@lexer.TokenKind],
) -> @ast.Expr raise ParseError {
  let items : Array[@ast.Subexpr] = []
  while not(self.is_at_end()) {
    self.skip_comments()
    if self.is_stop_token(stops) {
      break
    }
    items.push(self.parse_subexpr())
  }
  @ast.Expr::new(items~)
}

///|
/// Returns true if the current token matches any stop token.
fn Parser::is_stop_token(
  self : Parser,
  stops : Array[@lexer.TokenKind],
) -> Bool {
  for stop in stops {
    if self.peek() == stop {
      return true
    }
  }
  false
}

///|
/// Returns true if the next token is '+'.
fn Parser::peek_next_is_plus(self : Parser) -> Bool {
  let next = self.pos + 1
  if next >= self.tokens.length() {
    return false
  }
  self.tokens[next].kind is Plus
}

///|
/// Parses a result type: type-ident { subexpr } or type-ident < subexpr >.
fn Parser::parse_result_type(self : Parser) -> @ast.ResultType raise ParseError {
  let (ns, name) = self.parse_type_ident_name()
  let type_ident = @ast.TypeIdent::new(name~, ns?)
  let params : Array[@ast.Subexpr] = []
  if self.peek() is LAngle {
    let _ = self.advance()
    params.push(self.parse_subexpr())
    while self.peek() is Comma {
      let _ = self.advance()
      params.push(self.parse_subexpr())
    }
    let _ = self.expect(RAngle)

  } else {
    while not(self.peek() is Semicolon) && not(self.is_at_end()) {
      params.push(self.parse_subexpr())
    }
  }
  { type_ident, params }
}

///|
/// Parses a type identifier name with optional namespace: ns.Name or Name.
fn Parser::parse_type_ident_name(
  self : Parser,
) -> (@ast.LowerIdent?, @ast.UpperIdent) raise ParseError {
  match self.peek() {
    LowerIdent(ns) => {
      let _ = self.advance()
      if self.peek() is Dot {
        let _ = self.advance()
        let name = self.parse_ident_name()
        (Some(@ast.LowerIdent::new(value=ns)), @ast.UpperIdent::new(value=name))
      } else {
        // It's actually a bare type name, lowercase allowed in result
        (None, @ast.UpperIdent::new(value=ns))
      }
    }
    UpperIdent(name) => {
      let _ = self.advance()
      (None, @ast.UpperIdent::new(value=name))
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="type identifier",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a final declaration: New/Final/Empty TypeIdent ;
fn Parser::parse_final_decl(self : Parser) -> @ast.FinalDecl raise ParseError {
  match self.peek() {
    New => {
      let start = self.current().span.start
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let end = self.current().span.end
      let _ = self.expect(Semicolon)
      let data = @ast.FinalDeclData::{
        type_ident: ident,
        span: @ast.Span::new(start~, end~),
      }
      @ast.FinalDecl::New(data)
    }
    Final => {
      let start = self.current().span.start
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let end = self.current().span.end
      let _ = self.expect(Semicolon)
      let data = @ast.FinalDeclData::{
        type_ident: ident,
        span: @ast.Span::new(start~, end~),
      }
      @ast.FinalDecl::Final(data)
    }
    Empty => {
      let start = self.current().span.start
      let _ = self.advance()
      let ident = self.parse_type_ident()
      let end = self.current().span.end
      let _ = self.expect(Semicolon)
      let data = @ast.FinalDeclData::{
        type_ident: ident,
        span: @ast.Span::new(start~, end~),
      }
      @ast.FinalDecl::Empty(data)
    }
    _ => {
      let token = self.current()
      raise ParseError::UnexpectedToken(
        pos=token.span.start,
        expected="final declaration (New, Final, or Empty)",
        found=token.kind.to_string(),
      )
    }
  }
}

///|
/// Parses a type identifier: ns.Name or Name.
fn Parser::parse_type_ident(self : Parser) -> @ast.TypeIdent raise ParseError {
  let (ns, name) = self.parse_type_ident_name()
  @ast.TypeIdent::new(name~, ns?)
}
