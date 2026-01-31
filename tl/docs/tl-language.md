# TL Language Specification

## Overview

TL (Type Language) serves to describe the used system of types, constructors, and existing functions. It employs a combinator description format for binary data serialization, enabling precise type-safe communication in distributed systems.

## Purpose

TL provides a formal way to:
- Define data types and their constructors
- Specify RPC functions and their signatures
- Ensure type safety during serialization/deserialization
- Support versioning and backward compatibility

## Program Structure

A typical TL program contains two main sections divided by `---functions---`:

### 1. Type Section

Declarations of built-in and aggregate types with their constructors. This section defines the data structures used in the system.

### 2. Function Section

Functional combinators and RPC functions that operate on the defined types.

### Section Markers

- `---types---`: Optional keyword that can reintroduce type declarations after functions
- `---functions---`: Separates type declarations from function declarations
- Special rule: You can declare functions in the type section when results begin with an exclamation point

## Syntax Rules

### Combinator Declaration Format

Each combinator declaration ends with a semicolon (`;`). Combinators may include explicit 32-bit identifiers using hash notation:

```tl
user#d23c81a3 id:int first_name:string = User;
```

The hash notation `#d23c81a3` explicitly assigns a 32-bit identifier to the combinator.

### Namespaces

Composite identifiers support namespace organization:

- **Type names**: `auth.Message` (capitalized)
- **Constructor names**: `auth.std_message` (lowercase)
- No special declaration required for namespaces

Examples:
```tl
auth.std_message text:string = auth.Message;
storage.fileJpeg = storage.FileType;
```

### Comments

TL supports C++-style comments:

```tl
// Single-line comment

/* Multi-line
   comment */
```

### Identifiers

- **Type identifiers**: Begin with uppercase letter (e.g., `User`, `Message`)
- **Constructor identifiers**: Begin with lowercase letter (e.g., `user`, `std_message`)
- **Field names**: Lowercase with underscores (e.g., `first_name`, `user_id`)

## Built-in Types

TL includes several fundamental types:

- `int` - 32-bit signed integer
- `long` - 64-bit signed integer
- `double` - 64-bit floating point (IEEE 754)
- `string` - UTF-8 string with length prefix
- `null` - Empty/void type

### Generic Types

- `vector` - Polymorphic sequence type
- Parameterized types with type variables

Example:
```tl
vector {t:Type} # [ t ] = Vector t;
```

## Composite Types

Custom aggregate types combine multiple fields:

```tl
pair x:Object y:Object = Pair;
user#d23c81a3 id:int first_name:string last_name:string = User;
```

### Field Declaration

Fields are declared with the syntax: `field_name:type_expr`

Example:
```tl
message id:long from_id:int text:string date:int = Message;
```

## Serialization Basics

TL serialization yields sequences of 32-bit integers. When embedded into byte streams, each integer uses little-endian byte order.

### Type Context

Type context prevents ambiguity during serialization and deserialization. The deserializer knows what type to expect at each position, eliminating the need for runtime type tags in many cases.

### Boxed vs. Bare Types

- **Boxed types**: Include a constructor number at the beginning
- **Bare types**: Omit the constructor number when type is known from context

## Code Examples

### Simple Type Definition

```tl
boolFalse = Bool;
boolTrue = Bool;
```

### Parameterized Type

```tl
nil {X:Type} = List X;
cons {X:Type} x:X xs:(List X) = List X;
```

### Multiple Constructors

```tl
messageEmpty id:long = Message;
message id:long from_id:int text:string date:int = Message;
messageForwarded id:long fwd_from_id:int text:string date:int = Message;
```

### Functions

```tl
---functions---
getUser id:int = User;
sendMessage user_id:int text:string = Message;
```

## Advanced Topics

For more detailed information, see:
- [TL Combinators](tl-combinators.md) - Formal combinator specification
- [Binary Serialization](tl-serialization.md) - Detailed serialization rules
- [TL Schema Format](tl-schema.md) - Schema serialization and binary format

## References

- Official Telegram Documentation: https://core.telegram.org/mtproto/TL
