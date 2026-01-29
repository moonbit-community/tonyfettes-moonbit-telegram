///|
/// Generates a schema that references an undefined type.
/// The undefined type is used in an argument, not the result type
/// (since result types are defined by the combinator itself).
fn gen_schema_with_undefined_type() -> @qc.Gen[@ast.Schema] {
  // Generate a combinator that uses an undefined type in an argument
  let undefined_type_gen = @internal_qc.gen_upper_ident().fmap(fn(name) {
    // Use an unlikely namespace prefix to ensure it's undefined
    @ast.TypeIdent::namespaced("__undefined__", name)
  })
  @qc.liftA3(
    fn(undefined_ident, combinator_name, result_type_name) {
      // The argument references an undefined type
      let arg : @ast.Arg = @ast.Arg::Named({
        name: "x",
        conditional: None,
        bang: false,
        type_: @ast.Term::Ident(undefined_ident),
      })
      let result : @ast.ResultType = {
        type_ident: @ast.TypeIdent::simple(result_type_name),
        params: [],
      }
      let combinator : @ast.Combinator = {
        ns: None,
        name: combinator_name,
        id: None,
        opt_args: [],
        args: [arg],
        result,
        span: @internal_qc.dummy_span(),
      }
      {
        types: [@ast.Declaration::Combinator(combinator)],
        functions: [],
        comments: [],
      }
    },
    undefined_type_gen,
    @internal_qc.gen_lower_ident(),
    @internal_qc.gen_upper_ident(),
  )
}

///|
/// Generates a schema with duplicate constructor names.
fn gen_schema_with_duplicate_name() -> @qc.Gen[@ast.Schema] {
  @qc.liftA2(
    fn(name, result_type_name) {
      let result : @ast.ResultType = {
        type_ident: @ast.TypeIdent::simple(result_type_name),
        params: [],
      }
      let combinator1 : @ast.Combinator = {
        ns: None,
        name,
        id: Some(0x12345678U),
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }
      let combinator2 : @ast.Combinator = {
        ns: None,
        name, // Same name = duplicate!
        id: Some(0x87654321U), // Different ID
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }
      {
        types: [
          @ast.Declaration::Combinator(combinator1),
          @ast.Declaration::Combinator(combinator2),
        ],
        functions: [],
        comments: [],
      }
    },
    @internal_qc.gen_lower_ident(),
    @internal_qc.gen_upper_ident(),
  )
}

///|
/// Generates a schema that violates Final type constraints.
/// A Final type cannot have new constructors added after Final is declared.
fn gen_schema_with_final_violation() -> @qc.Gen[@ast.Schema] {
  @qc.liftA3(
    fn(type_name, ctor1_name, ctor2_name) {
      let type_ident = @ast.TypeIdent::simple(type_name)
      let result : @ast.ResultType = { type_ident, params: [] }

      // First combinator - creates the type
      let combinator1 : @ast.Combinator = {
        ns: None,
        name: ctor1_name,
        id: Some(0x11111111U),
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }

      // Final declaration
      let final_decl : @ast.FinalDecl = @ast.FinalDecl::Final({
        type_ident,
        span: @internal_qc.dummy_span(),
      })

      // Second combinator - violates Final!
      let combinator2 : @ast.Combinator = {
        ns: None,
        name: ctor2_name,
        id: Some(0x22222222U),
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }
      {
        types: [
          @ast.Declaration::Combinator(combinator1),
          @ast.Declaration::Final(final_decl),
          @ast.Declaration::Combinator(combinator2),
        ],
        functions: [],
        comments: [],
      }
    },
    @internal_qc.gen_upper_ident(),
    @internal_qc.gen_lower_ident(),
    // Ensure second constructor has a different name
    @internal_qc.gen_lower_ident().fmap(fn(name) { name + "_2" }),
  )
}

///|
/// Generates a schema that violates Empty type constraints.
/// An Empty type cannot have constructors.
fn gen_schema_with_empty_violation() -> @qc.Gen[@ast.Schema] {
  @qc.liftA2(
    fn(type_name, ctor_name) {
      let type_ident = @ast.TypeIdent::simple(type_name)
      let result : @ast.ResultType = { type_ident, params: [] }

      // Empty declaration first
      let empty_decl : @ast.FinalDecl = @ast.FinalDecl::Empty({
        type_ident,
        span: @internal_qc.dummy_span(),
      })

      // Combinator that violates Empty
      let combinator : @ast.Combinator = {
        ns: None,
        name: ctor_name,
        id: Some(0x33333333U),
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }
      {
        types: [
          @ast.Declaration::Final(empty_decl),
          @ast.Declaration::Combinator(combinator),
        ],
        functions: [],
        comments: [],
      }
    },
    @internal_qc.gen_upper_ident(),
    @internal_qc.gen_lower_ident(),
  )
}

///|
/// Generates a schema that violates New type constraints.
/// A New type cannot have constructors before the New declaration.
fn gen_schema_with_new_violation() -> @qc.Gen[@ast.Schema] {
  @qc.liftA2(
    fn(type_name, ctor_name) {
      let type_ident = @ast.TypeIdent::simple(type_name)
      let result : @ast.ResultType = { type_ident, params: [] }

      // Combinator first - creates constructors before New
      let combinator : @ast.Combinator = {
        ns: None,
        name: ctor_name,
        id: Some(0x44444444U),
        opt_args: [],
        args: [],
        result,
        span: @internal_qc.dummy_span(),
      }

      // New declaration - but constructors already exist!
      let new_decl : @ast.FinalDecl = @ast.FinalDecl::New({
        type_ident,
        span: @internal_qc.dummy_span(),
      })
      {
        types: [
          @ast.Declaration::Combinator(combinator),
          @ast.Declaration::Final(new_decl),
        ],
        functions: [],
        comments: [],
      }
    },
    @internal_qc.gen_upper_ident(),
    @internal_qc.gen_lower_ident(),
  )
}

///|
/// Property: Schemas with undefined type references should be detected.
test "undefined type reference detected" {
  @qc.quick_check(
    @qc.forall(gen_schema_with_undefined_type(), fn(schema) {
      let result = try? type_schema(schema)
      result is Err(UndefinedType(..))
    }),
    max_success=50,
    max_size=10,
  )
}

///|
/// Property: Schemas with duplicate constructor names should be detected.
test "duplicate constructor name detected" {
  @qc.quick_check(
    @qc.forall(gen_schema_with_duplicate_name(), fn(schema) {
      let result = try? type_schema(schema)
      result is Err(DuplicateConstructorName(..))
    }),
    max_success=50,
    max_size=10,
  )
}

///|
/// Property: Final type violations should be detected.
test "Final type violation detected" {
  @qc.quick_check(
    @qc.forall(gen_schema_with_final_violation(), fn(schema) {
      let result = try? type_schema(schema)
      result is Err(FinalTypeViolation(..))
    }),
    max_success=50,
    max_size=10,
  )
}

///|
/// Property: Empty type violations should be detected.
test "Empty type violation detected" {
  @qc.quick_check(
    @qc.forall(gen_schema_with_empty_violation(), fn(schema) {
      let result = try? type_schema(schema)
      result is Err(EmptyTypeViolation(..))
    }),
    max_success=50,
    max_size=10,
  )
}

///|
/// Property: New type violations should be detected.
test "New type violation detected" {
  @qc.quick_check(
    @qc.forall(gen_schema_with_new_violation(), fn(schema) {
      let result = try? type_schema(schema)
      result is Err(NewTypeViolation(..))
    }),
    max_success=50,
    max_size=10,
  )
}

///|
/// Property: CRC32 is deterministic.
/// Computing CRC32 of the same normalized combinator should always yield the same result.
test "CRC32 is deterministic" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_combinator(), fn(combinator) {
      let norm1 = normalize_combinator(combinator)
      let norm2 = normalize_combinator(combinator)
      let crc1 = crc32(norm1)
      let crc2 = crc32(norm2)
      crc1 == crc2
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Property: CRC32 ignores span differences.
/// Two combinators that differ only in their span should have the same CRC32.
test "CRC32 ignores spans" {
  @qc.quick_check(
    @qc.forall(@internal_qc.gen_combinator(), fn(combinator) {
      // Create same combinator with different spans
      let c1 = { ..combinator, span: @internal_qc.dummy_span() }
      let c2 = {
        ..combinator,
        span: @ast.Span::new(
          start=@ast.Position::new(line=999, column=999, offset=999),
          end=@ast.Position::new(line=1000, column=1000, offset=1000),
        ),
      }
      crc32(normalize_combinator(c1)) == crc32(normalize_combinator(c2))
    }),
    max_success=100,
    max_size=20,
  )
}
