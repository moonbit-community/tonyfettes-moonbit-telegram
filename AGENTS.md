# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoonBit Telegram Bot API library (`tonyfettes/telegram`). Provides typed wrappers around the Telegram Bot HTTP API with async support via `moonbitlang/async`.

## Commands

```bash
moon check          # Type check
moon fmt            # Format code
moon test           # Run all tests
moon test -p bot -F "User JSON"  # Run specific test by name pattern
moon info           # Generate .mbti interface files
```

## Commit Style

- Single commit: `<type>(<scope>): <description>`
- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- Include a brief body explaining what and why.
- Always include the `Co-Authored-By` trailer.

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<body explaining what and why>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)"
```

## Architecture

### Package Structure

- `bot/` - Main package containing all Telegram Bot API types and methods
  - `bot.mbt` - `Bot` struct and API methods (`get_me`, `send_message`, `get_updates`, etc.)
  - `error.mbt` - `TelegramError` suberror type for all API errors
  - Type files: `user.mbt`, `chat.mbt`, `message.mbt`, `update.mbt`, `callback_query.mbt`, `inline_keyboard.mbt`, `bot_command.mbt`, `message_id.mbt`

### Code Patterns

**Type definitions** follow this pattern:

1. Struct with `derive(Show, Eq)` (add `ToJson, FromJson` if no custom serialization needed)
2. Constructor function `Type::new()` with labeled parameters (required fields use `~`, optional use `?`)
3. Custom `ToJson`/`FromJson` implementations when JSON field names differ (e.g., `type_` -> `"type"`)

**Custom JSON serialization** (for types with optional fields or renamed fields):

```moonbit
pub impl @json.ToJson for Type with to_json(self) {
  let object : Map[String, Json] = { "required": @json.to_json(self.required) }
  if self.optional is Some(v) {
    object["optional"] = @json.to_json(v)
  }
  @json.to_json(object)
}

pub impl @json.FromJson for Type with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError((path, "Expected object for Type"))
  }
  let required : T = @json.from_json(object["required"], path~)
  let optional : T? = if object.get("optional") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { required, optional }
}
```

**API methods** follow this pattern:

```moonbit
pub async fn Bot::method_name(
  self : Bot,
  required~ : Type,
  optional? : Type,
) -> ReturnType raise TelegramError {
  let url = self.api_url("methodName")
  let body : Map[String, Json] = { "required": @json.to_json(required) }
  if optional is Some(v) {
    body["optional"] = @json.to_json(v)
  }
  // HTTP POST, error handling, parse_api_response(data)
}
```

**Tests** use JSON round-trip pattern:

```moonbit
test "Type JSON round-trip" {
  let object = Type::new(field=value)
  let json = @json.to_json(object)
  let parsed : Type = @json.from_json(json)
  inspect(parsed.field, content="expected")
}
```

### Single-field struct constructors

Use trailing comma to avoid ambiguous block warning:

```moonbit
{ single_field, }  // correct
{ single_field }   // warning
```
