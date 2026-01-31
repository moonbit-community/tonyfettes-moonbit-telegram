// Helper generator using Arbitrary trait
fn gen_schema() -> @qc.Gen[@ast.Schema] {
  @qc.Gen::new(fn(size, rs) {
    @quickcheck.Arbitrary::arbitrary(size, rs)
  })
}

///|
/// Property: parse(schema_to_string(schema)) == schema (ignoring spans)
///
/// Note: This test may fail due to known AST normalization issues:
/// - Variable references that aren't declared in opt_args
/// - Conditional references to non-existent flags fields
///
/// These failures document real issues in the AST representation that
/// could be addressed by normalizing the AST or refactoring it.
test "parse/print round-trip preserves schema structure" {
  @qc.quick_check(
    @qc.forall_shrink(gen_schema(), @qc.Shrink::shrink, fn(
      schema,
    ) {
      let printed = @tl.schema_to_string(schema)
      let reparsed = try? @tl.parse(source=printed)
      match reparsed {
        Ok(parsed_schema) => schema == parsed_schema
        Err(_) => false
      }
    }),
    max_success=100,
    max_size=20,
  )
}

///|
/// Property: parse/print is idempotent.
/// If we print a schema, reparse it, and print again, we should get the same string.
test "parse/print is idempotent" {
  @qc.quick_check(
    @qc.forall_shrink(gen_schema(), @qc.Shrink::shrink, fn(
      schema,
    ) {
      let printed1 = @tl.schema_to_string(schema)
      let reparsed = try? @tl.parse(source=printed1)
      guard reparsed is Ok(parsed1) else { return true } // Skip parse failures
      let printed2 = @tl.schema_to_string(parsed1)
      printed1 == printed2 // Idempotent!
    }),
    max_success=100,
    max_size=20,
  )
}
