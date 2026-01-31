# TL (Type Language) Documentation

## What is TL?

TL (Type Language) is a formal language for describing data types, constructors, and functions used in binary data serialization. It was developed for the MTProto protocol used by Telegram, but provides a general-purpose system for type-safe communication in distributed systems.

**Key Features**:
- Strong static typing with type inference
- Efficient binary serialization (32-bit word sequences)
- Support for polymorphic and dependent types
- Versioning through multiple constructors
- Compact wire format with optional type tags

## Purpose in This Project

This MoonBit Telegram Bot API library includes TL documentation because:

1. **Understanding Telegram API**: The Telegram Bot API types are derived from TL schemas
2. **Type Safety**: TL's type system informs our MoonBit type definitions
3. **Serialization**: Understanding TL serialization helps with JSON↔Binary conversions
4. **Schema Evolution**: TL versioning patterns guide our API compatibility strategies
5. **Reference**: Quick lookup for TL syntax when working with Telegram schemas

## Documentation Files

### [TL Language Specification](tl-language.md)

The main language reference covering:
- TL program structure (types and functions sections)
- Syntax rules (comments, identifiers, namespaces)
- Built-in types (int, long, double, string)
- Composite types and constructors
- Basic serialization concepts
- Code examples

**Start here** if you're new to TL.

### [TL Combinators](tl-combinators.md)

Formal specification for combinator declarations:
- Combinator declaration syntax
- Optional field declarations (`{field:Type}`)
- Required field declarations
- Repetitions and array syntax (`count*[Type]`)
- Conditional fields with bit flags (`flags.0?Type`)
- Dependent types and polymorphism examples

**Use this** when defining complex types with optional/conditional fields.

### [Binary Serialization](tl-serialization.md)

Detailed rules for converting TL types to/from binary:
- Core concepts (alphabet, values, types)
- Combinators and constructors
- Boxed vs. bare types
- Base type serialization (int, long, double, string)
- Built-in composite types (Vector, Hash types)
- Field names and versioning strategies
- Object pseudotype and polymorphism

**Use this** when implementing serialization/deserialization logic.

### [TL Schema Format](tl-schema.md)

The TL schema serialization specification:
- Overview of schema serialization
- Common built-in types
- Schema definition structure (tl.tl)
- Magic numbers and version detection
- Binary `.tlo` file format
- Schema deserialization process

**Use this** if working with TL schema files or implementing schema parsers.

## Quick Reference

### Basic Type Declaration

```tl
user id:int first_name:string last_name:string = User;
```

### Optional Fields

```tl
message flags:# text:(flags.0?string) photo:(flags.1?Photo) = Message;
```

### Polymorphic Types

```tl
vector {t:Type} # [ t ] = Vector t;
nil {X:Type} = List X;
cons {X:Type} x:X xs:(List X) = List X;
```

### Functions

```tl
---functions---
getUser id:int = User;
sendMessage user_id:int text:string = Message;
```

## External Resources

- **Official Telegram TL Documentation**: https://core.telegram.org/mtproto/TL
- **Telegram API Schema**: https://core.telegram.org/schema
- **MTProto Protocol**: https://core.telegram.org/mtproto

## Working with TL in MoonBit

While Telegram Bot API uses JSON (not binary TL), understanding TL helps because:

1. **Type Mapping**: TL types → MoonBit structs
   ```tl
   user id:int first_name:string = User;
   ```
   ```moonbit
   struct User {
     id : Int
     first_name : String
   }
   ```

2. **Optional Fields**: TL flags → MoonBit `Option[T]`
   ```tl
   message flags:# text:(flags.0?string) = Message;
   ```
   ```moonbit
   struct Message {
     text : String?
   }
   ```

3. **Polymorphism**: TL vectors → MoonBit `Array[T]`
   ```tl
   updates Vector<Update> = Updates;
   ```
   ```moonbit
   struct Updates {
     updates : Array[Update]
   }
   ```

## Contributing

When adding new Telegram API types to this library:

1. **Check the TL schema** for the canonical type definition
2. **Map TL types** to appropriate MoonBit types
3. **Handle optional fields** with `Option[T]`
4. **Implement ToJson/FromJson** following the patterns in `bot/` package
5. **Write tests** using JSON round-trip pattern

## License

This documentation is derived from official Telegram documentation and is provided for educational purposes within this project.
