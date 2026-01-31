# Binary Data Serialization in TL

## Overview

MTProto requires serialization of data types into binary format using the TL language. This document describes how TL types are converted to and from binary representations.

## Core Concepts

### Alphabet

The basic unit is a **32-bit number** (signed integer between -2³¹ and 2³¹ - 1). All serialized data consists of sequences of these 32-bit values transmitted in **little-endian byte order**.

### Value

A **value** is a finite sequence of 32-bit numbers. For example:

- `[42]` - Single integer
- `[100, 200, 300]` - Three integers
- `[]` - Empty sequence

### Type

A **type** is a set of legal values forming a **prefix code** where no element is a prefix of another. This ensures unambiguous deserialization - you can determine where a value ends without needing explicit length markers in many cases.

## Combinators & Constructors

### Combinator

A **combinator** is a transformation that takes arguments of specified types and returns another type. The **arity** indicates the number of arguments.

### Constructor

**Constructors** represent composite data types and cannot be reduced. They are the building blocks for creating complex types.

Example:

```tl
int_tree IntTree int IntTree = IntTree;
```

This defines a binary tree constructor that takes an IntTree (left), an int (value), and another IntTree (right) to produce an IntTree.

### Combinator Description Format

```
combinator_name type_arg_1 ... type_arg_N = type_res;
```

Components:

- **combinator_name**: Identifier (lowercase for bare, Capitalized for boxed)
- **type_arg_1 ... type_arg_N**: Argument types
- **type_res**: Result type

### Combinator Number

The **combinator number** is a 32-bit identifier typically computed as a CRC32 hash of the combinator declaration. Valid range: `0x01000000` to `0xffffff00`.

Example:

```tl
user#d23c81a3 id:int first_name:string = User;
```

The hash `#d23c81a3` is the combinator number.

## Boxed vs. Bare Types

### Boxed Types

**Boxed types** values begin with constructor numbers, guaranteeing type identification. Identifiers are capitalized (e.g., `IntTree`, `User`, `Message`).

Serialized format:

```
[constructor_number, field_1, field_2, ..., field_N]
```

**Advantage**: Self-describing, enables dynamic typing and polymorphism.

**Disadvantage**: 4 extra bytes per value.

### Bare Types

**Bare types** omit constructor numbers; they're implied by context. Identifiers use lowercase (e.g., `int_tree`) or `%BoxedName` notation.

Serialized format:

```
[field_1, field_2, ..., field_N]
```

**Advantage**: More compact. As noted, "an array of 10,000 bare int values is 40,000 bytes" versus 80,000 bytes for boxed equivalents.

**Disadvantage**: Requires known type context for deserialization.

### When to Use Each

- **Boxed**: When type may vary (polymorphism, Object type fields)
- **Bare**: When type is known from context (fixed schema fields)

## Base Types

Available as both bare and boxed versions:

### int

- **Bare**: Single 32-bit number
- **Size**: 4 bytes
- **Example**: `42` → `[0x0000002A]`

### long

- **Bare**: Two 32-bit numbers forming a 64-bit signed integer
- **Size**: 8 bytes
- **Byte order**: Little-endian within each 32-bit chunk
- **Example**: `0x0123456789ABCDEF` → `[0x89ABCDEF, 0x01234567]`

### double

- **Bare**: Two 32-bit numbers in IEEE 754 format
- **Size**: 8 bytes
- **Format**: Standard double-precision floating point

### string

- **Bare**: Length-prefixed with padding to 4-byte alignment
- **Format**:
  - If length ≤ 253: `[length_byte, data..., padding]`
  - If length ≥ 254: `[0xFE, length_3bytes, data..., padding]`
- **Padding**: Zeros to reach 4-byte boundary

Example:

```
"hello" (5 bytes) → [0x05, 'h', 'e', 'l', 'l', 'o', 0x00, 0x00] (8 bytes total)
```

## Built-in Composite Types

### Vector t

**Polymorphic sequence type** with constructor `0x1cb5c415`.

```tl
vector {t:Type} # [ t ] = Vector t;
```

**Serialization**:

```
[0x1cb5c415, count, element_1, element_2, ..., element_count]
```

Example:

```tl
vector {int} [1, 2, 3]
```

Serializes as:

```
[0x1cb5c415, 0x00000003, 0x00000001, 0x00000002, 0x00000003]
```

### Bare Vector

If type is known, can serialize as bare vector (no constructor number):

```
[count, element_1, element_2, ..., element_count]
```

### Hash Types

Associative arrays using vectors of key-value pairs:

- **IntHash t**: Keys are integers
- **StrHash t**: Keys are strings
- **IntSortedHash t**: Sorted by integer keys
- **StrSortedHash t**: Sorted by string keys

Typically implemented as:

```tl
intHash {t:Type} = IntHash t;  // Vector of (int, t) pairs
```

## Field Names and Versioning

Developers can assign names to structure fields for clarity:

```tl
user id:int first_name:string last_name:string = User;
```

**Benefits**:

- Improved maintainability
- Self-documenting schemas
- Enables versioning through extended constructors

**Versioning Example**:

```tl
user_v1 id:int name:string = User;
user_v2 id:int first_name:string last_name:string = User;
```

Both constructors implement `User` but with different fields.

## Object Pseudotype

The `Object` type accepts values from any **boxed type**, enabling flexible data structures:

```tl
pair x:Object y:Object = Pair;
```

**Characteristics**:

- Introduces dynamic typing
- Requires boxed values (with constructor numbers)
- Less type-safe than alternatives

**Recommended Alternative**: Use `TypedObject` or explicit union types for type safety.

## Polymorphic Types

Polymorphic constructors remain independent of specific type parameters. Optional parameters in curly braces (type variables) are not serialized.

Example:

```tl
nil {X:Type} = List X;
cons {X:Type} x:X xs:(List X) = List X;
```

**Serialization**:

- Type parameter `{X:Type}` is **not serialized**
- Only actual data fields (`x`, `xs`) are serialized
- Type information derived from context during deserialization

### Type Inference

The system derives parameter types from context:

```tl
cons {X:int} x:42 xs:nil = List int
```

The type `X = int` is inferred from the context and field types, not explicitly transmitted.

## Serialization Examples

### Simple Type

```tl
boolTrue = Bool;
```

Serializes as:

```
[0x997275b5]  // Constructor number only
```

### Complex Type

```tl
user#d23c81a3 id:int first_name:string last_name:string = User;
```

For user `{ id: 123, first_name: "John", last_name: "Doe" }`:

```
[
  0xd23c81a3,           // Constructor
  0x0000007B,           // id = 123
  0x044A6F686E,         // first_name = "John" (length 4 + data)
  0x03446F6500,         // last_name = "Doe" (length 3 + data + padding)
]
```

### Vector Example

```tl
vector {int} [10, 20, 30]
```

Serializes as:

```
[
  0x1cb5c415,           // Vector constructor
  0x00000003,           // Count = 3
  0x0000000A,           // 10
  0x00000014,           // 20
  0x0000001E,           // 30
]
```

## Deserialization Process

1. **Read constructor number** (if boxed type expected)
2. **Look up constructor** in schema to find field types
3. **Read each field** according to its type:
   - Base types: Read fixed number of 32-bit words
   - Strings: Read length, then data with padding
   - Vectors: Read count, then elements
   - Nested types: Recursively deserialize
4. **Construct value** from deserialized fields

## Best Practices

1. **Use bare types** for known-type fields to save space
2. **Use boxed types** for polymorphic fields or Object type
3. **Align strings** properly to 4-byte boundaries
4. **Validate lengths** before allocating buffers
5. **Check constructor numbers** against schema
6. **Handle versioning** through multiple constructors
7. **Document bit flags** for conditional fields

## References

- Official Telegram Documentation: <https://core.telegram.org/mtproto/serialize>
- [TL Language](tl-language.md) - Language specification
- [TL Combinators](tl-combinators.md) - Combinator syntax
- [TL Schema Format](tl-schema.md) - Schema serialization
