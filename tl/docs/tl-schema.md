# TL Schema Serialization

## Overview

TL schemas can be converted into binary format for efficient parsing and processing. Rather than requiring each program to parse text-based `.tl` files, this approach allows creation of `.tlo` binary files that need only a deserializer based on the schema specification.

**Advantages**:
- Faster loading (binary parsing vs. text parsing)
- Smaller file size (compact binary representation)
- Type-safe deserialization with schema validation
- Portable across different implementations

## Common Built-In Types

The foundation includes several primitive types and structures:

### Primitives

- `int` - 32-bit signed integer
- `long` - 64-bit signed integer
- `double` - 64-bit floating point
- `string` - Length-prefixed UTF-8 string

### Boolean

```tl
boolFalse = Bool;
boolTrue = Bool;
```

Two constructors representing the `Bool` type.

### Collections

- `vector {t:Type} # [ t ] = Vector t` - Dynamic arrays
- `tuple` - Fixed-size collections
- `vectorTotal` - Vectors with explicit counts

### Utility Types

- `Empty` - Empty/void type
- `true` - Constant true value (different from `boolTrue`)

## Core Schema Structure (tl.tl)

The schema definition comprises several interconnected types that describe TL schemas themselves.

### Schema Container

```tl
tls.schema_v2 version:int date:int types_num:# types:types_num*[tls.Type]
              constructors_num:# constructors:constructors_num*[tls.Combinator]
              functions_num:# functions:functions_num*[tls.Combinator] = tls.Schema;
```

**Fields**:
- `version` - Schema version number
- `date` - Unix timestamp of schema creation
- `types_num` - Number of type definitions
- `types` - Array of type definitions
- `constructors_num` - Number of constructors
- `constructors` - Array of constructor combinators
- `functions_num` - Number of functions
- `functions` - Array of function combinators

### Type Definition

```tl
tls.type id:int name:string constructors_num:# constructors:constructors_num*[int]
         flags:# = tls.Type;
```

**Fields**:
- `id` - Unique type identifier
- `name` - Type name (e.g., "User", "Message")
- `constructors_num` - Number of constructors for this type
- `constructors` - Array of constructor IDs
- `flags` - Type flags (reserved for future use)

### Combinator Definition

```tl
tls.combinator id:int name:string type_id:int left_num:# left:left_num*[tls.Arg]
               right_num:# right:right_num*[tls.TypeExpr] = tls.Combinator;
```

**Fields**:
- `id` - Combinator number (constructor hash)
- `name` - Combinator name
- `type_id` - Result type identifier
- `left_num` - Number of left-hand arguments
- `left` - Array of argument definitions
- `right_num` - Number of right-hand type expressions
- `right` - Array of type expressions for the result

### Argument Definition

```tl
tls.arg name:string flags:# conditional_def:(flags.0?tls.ConditionalDef)
        type:tls.TypeExpr = tls.Arg;
```

**Fields**:
- `name` - Argument name
- `flags` - Argument flags
- `conditional_def` - Optional condition (e.g., `flags.0?type`)
- `type` - Type expression for this argument

### Conditional Definition

```tl
tls.conditionalDef var_name:string bit_selector:# = tls.ConditionalDef;
```

**Fields**:
- `var_name` - Name of the flags variable
- `bit_selector` - Bit number to test (e.g., 0 for `flags.0?`)

### Type Expression

```tl
tls.typeExpr name:string children_num:# children:children_num*[tls.TypeExpr]
             flags:# = tls.TypeExpr;

tls.typeExprArray multiplicity:tls.NatExpr element:tls.TypeExpr = tls.TypeExpr;
```

**Type expressions** handle:
- Named types with type parameters (children)
- Array types with multiplicity expressions

### Natural Number Expression

```tl
tls.natConst value:# = tls.NatExpr;
tls.natVar name:string = tls.NatExpr;
```

Used for array multiplicities and counts:
- `natConst` - Literal number (e.g., `5`, `10`)
- `natVar` - Variable reference (e.g., `rows`, `count`)

## Magic Number & Versioning

### Magic Number

The constant **`0x3a2f9be2`** serves as the magic number for version 2 format.

**Derivation**: CRC32 hash of the main schema declaration:
```tl
tls.schema_v2 version:int date:int ...
```

### Version Detection

When reading a `.tlo` file:
1. Read first 4 bytes as constructor number
2. Check if it matches `0x3a2f9be2` (schema_v2)
3. If match, deserialize as schema_v2
4. If no match, try other versions or report error

### Future Versioning

Future extensions would introduce new constructors (e.g., `tls.schema_v3`) with distinct identifiers rather than modifying existing structures.

Example:
```tl
tls.schema_v3 version:int date:int types_num:# types:types_num*[tls.Type]
              constructors_num:# constructors:constructors_num*[tls.Combinator]
              functions_num:# functions:functions_num*[tls.Combinator]
              metadata:string = tls.Schema;  // New field
```

This would have a different magic number derived from its CRC32 hash.

## Binary Format Structure

A `.tlo` file contains:

```
[Magic Number]           (4 bytes) - 0x3a2f9be2 for v2
[Version]                (4 bytes) - Schema version number
[Date]                   (4 bytes) - Unix timestamp
[Types Count]            (4 bytes) - Number of types
[Types Array]            (variable) - Serialized tls.Type objects
[Constructors Count]     (4 bytes) - Number of constructors
[Constructors Array]     (variable) - Serialized tls.Combinator objects
[Functions Count]        (4 bytes) - Number of functions
[Functions Array]        (variable) - Serialized tls.Combinator objects
```

### Example Binary Format

For a simple schema:
```tl
boolFalse = Bool;
boolTrue = Bool;
```

The `.tlo` file would contain:
```
0x3a2f9be2              // Magic number
0x00000002              // Version 2
0x65A8B4C0              // Date (example timestamp)
0x00000001              // 1 type (Bool)
[Bool type definition]
0x00000002              // 2 constructors
[boolFalse combinator]
[boolTrue combinator]
0x00000000              // 0 functions
```

## Schema Deserialization Process

1. **Read magic number** and verify format version
2. **Read schema metadata** (version, date)
3. **Read types array**:
   - Read count
   - Deserialize each type definition
   - Build type registry
4. **Read constructors array**:
   - Read count
   - Deserialize each combinator
   - Index by combinator ID
5. **Read functions array**:
   - Read count
   - Deserialize each function combinator
   - Build function registry

## Usage in Implementation

### Loading Schema

```moonbit
fn load_schema(path : String) -> Schema!Error {
  let bytes = read_file(path)?
  let magic = read_int32(bytes, 0)
  if magic != 0x3a2f9be2 {
    raise Error::InvalidMagic(magic)
  }
  deserialize_schema_v2(bytes)
}
```

### Type Lookup

```moonbit
fn get_type_by_name(schema : Schema, name : String) -> Type? {
  schema.types.iter().find(fn(t) { t.name == name })
}
```

### Constructor Lookup

```moonbit
fn get_constructor_by_id(schema : Schema, id : Int) -> Combinator? {
  schema.constructors.iter().find(fn(c) { c.id == id })
}
```

## Best Practices

1. **Validate magic number** before attempting deserialization
2. **Check version compatibility** to ensure correct parsing
3. **Build indexes** (by name, by ID) after loading for fast lookups
4. **Cache loaded schemas** to avoid repeated disk I/O
5. **Validate schema integrity** (check all referenced types exist)
6. **Handle version migrations** gracefully with fallbacks

## Comparison: Text vs Binary

| Aspect | Text (.tl) | Binary (.tlo) |
|--------|-----------|---------------|
| **Size** | Larger (human-readable) | Smaller (compact) |
| **Load time** | Slower (parsing) | Faster (deserialization) |
| **Human readable** | Yes | No |
| **Validation** | Parse-time | Type-safe |
| **Portability** | High | High |
| **Use case** | Development, documentation | Production, runtime |

## References

- Official Telegram Documentation: https://core.telegram.org/mtproto/TL-tl
- [TL Language](tl-language.md) - Language specification
- [TL Combinators](tl-combinators.md) - Combinator syntax
- [Binary Serialization](tl-serialization.md) - Serialization rules
