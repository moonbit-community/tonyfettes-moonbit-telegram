# TL Combinators Specification

## Overview

This document provides the formal specification for TL combinator declarations, including syntax rules for optional fields, required fields, repetitions, and conditional fields.

## Combinator Declaration Syntax

The formal structure follows this pattern:

```
combinator-decl ::= full-combinator-id { opt-args } { args } = result-type ;
```

### Components

- **full-combinator-id**: Combinator identifier with optional explicit hash
- **opt-args**: Optional field declarations in curly braces `{...}`
- **args**: Required field declarations
- **result-type**: The type this combinator constructs
- **;**: Semicolon terminator

## Identifiers and Naming

### Combinator Identifiers

Combinator identifiers use lowercase Latin letters, optionally prefixed with a namespace:

- Simple: `cons`, `user`, `message`
- Namespaced: `lists.get`, `auth.sentCode`, `storage.fileJpeg`

### Combinator Numbers

A combinator has a **name**, also known as a **number** (not to be confused with the **designation**) -- a 32-bit number that either:

1. **Calculates automatically**: CRC32 hash of the combinator declaration
2. **Receives explicit assignment**: Via hash mark followed by 8 hexadecimal digits

Example:
```tl
user#d23c81a3 id:int first_name:string = User;
```

The explicit number `#d23c81a3` overrides automatic calculation.

## Optional Field Declarations

Optional fields use braces syntax:

```tl
{ field_1 ... field_k : type-expr }
```

### Key Constraints

1. **All optional fields must be explicitly named** - Using `_` instead of `field_i` is not allowed
2. **Type restrictions**: Optional fields must be type `#` (nat) or `Type`
3. **Purpose**: Enable implicit parameter resolution and type inference

### Examples

```tl
vector {t:Type} # [ t ] = Vector t;
```

Here, `{t:Type}` is an optional type parameter that can be inferred from context.

```tl
nil {X:Type} = List X;
cons {X:Type} x:X xs:(List X) = List X;
```

The type parameter `X` is declared as optional and used in the field types.

## Required Field Declarations

Required fields appear in parentheses `( field_1 ... field_k : type-expr )` or standalone.

### Syntax

```tl
field-name : type-expr
```

or grouped:

```tl
( field-1 field-2 ... : type-expr )
```

### Anonymous Fields

The underscore sign (`_`) can be used as names of one or more fields (`field_i`), indicating that the field is anonymous:

```tl
user _ id:int first_name:string = User;
```

This indicates unnamed parameters that are present in serialization but not exposed in the API.

### Examples

```tl
user id:int first_name:string last_name:string = User;
message id:long from_id:int text:string date:int = Message;
```

## Repetitions

Repetitions use bracket notation to define repeated fields or vectors:

```
[ field-id : ] [ multiplicity * ] [ args ]
```

### Components

- **field-id**: Optional name for the repeated structure
- **multiplicity**: Expression for vector length (constants or field references)
- **args**: Field declarations to repeat

### Equivalence

Functionally, the repetition `field-id : multiplicity * [ args ]` is equivalent to the declaration of a single field wrapped in an auxiliary tuple type.

### Examples

```tl
matrix rows:# cols:# data:rows*cols*[ double ] = Matrix;
```

This creates a matrix with `rows × cols` double values.

```tl
vector {t:Type} # [ t ] = Vector t;
```

The `#` indicates a natural number (count), and `[ t ]` repeats the type `t` that many times.

### Multiplicity Expressions

Multiplicity can be:
- Constants: `5`, `10`
- Field references: `rows`, `count`
- Expressions: `(c + v)`, `(rows * cols)`

Example:
```tl
rgb_matrix w:# h:# pixels:(w*h)*[ r:# g:# b:# ] = RgbMatrix;
```

## Conditional Fields

Conditional fields activate based on preceding `#`-type field values:

```
var-ident : [ var-ident [ . nat-const ] ? ] [ ! ] type-term
```

### Bit Flags Pattern

The most common pattern uses a `flags:#` field with bit testing:

```tl
user {fields:#} id:int first_name:(fields.0?string) last_name:(fields.1?string) = User;
```

### Syntax Components

- **fields:#**: A flags field of type nat
- **fields.0?type**: Field present if bit 0 of `fields` is set
- **fields.1?type**: Field present if bit 1 of `fields` is set

### Examples

```tl
message flags:# id:long from_id:(flags.0?int) text:(flags.1?string) date:int = Message;
```

If `flags` has bit 0 set, `from_id` field is present. If bit 1 is set, `text` field is present.

```tl
inputMediaUploadedPhoto flags:# file:InputFile caption:(flags.0?string) stickers:(flags.1?Vector<InputDocument>) = InputMedia;
```

Multiple optional fields controlled by different flag bits.

### Conditional Syntax Variations

- `field.N?type` - Present if bit N is set
- `field?type` - Present if field is non-zero (truthy)
- `!type` - Field is required (not serialized, computed)

## Dependent Types Examples

### Polymorphic Lists

```tl
nil {X:Type} = List X;
cons {X:Type} x:X xs:(List X) = List X;
```

The type parameter `X` makes the list polymorphic.

### Parameterized Containers

```tl
pair {X:Type} {Y:Type} x:X y:Y = Pair X Y;
```

Pairs can hold values of any two types.

### Type Classes

```tl
vector {t:Type} # [ t ] = Vector t;
intHash {t:Type} = IntHash t;
```

Generic container types parameterized over element types.

## Best Practices

1. **Use explicit hash numbers** for stability across versions
2. **Name all optional fields** (no anonymous optional fields)
3. **Use flags for conditional fields** to minimize bandwidth
4. **Group related conditionals** under the same flags field
5. **Document bit assignments** when using flag fields

## References

- Official Telegram Documentation: https://core.telegram.org/mtproto/TL-combinators
- [TL Language](tl-language.md) - Main language specification
- [Binary Serialization](tl-serialization.md) - How combinators are serialized
