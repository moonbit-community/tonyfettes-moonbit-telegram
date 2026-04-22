///|
/// Compatibility Show implementations for types migrated from derive(Show).
fn compact_debug_string(s : String) -> String {
  let sb = StringBuilder::new()
  let mut pending_comma = false
  let mut skip_indent = false
  let mut in_string = false
  let mut escaped = false
  for ch in s {
    if in_string {
      if pending_comma {
        sb.write_string(", ")
        pending_comma = false
      }
      sb.write_char(ch)
      if escaped {
        escaped = false
      } else if ch == '\\' {
        escaped = true
      } else if ch == '"' {
        in_string = false
      }
    } else {
      match ch {
        '"' => {
          if pending_comma {
            sb.write_string(", ")
            pending_comma = false
          }
          sb.write_char(ch)
          in_string = true
          skip_indent = false
        }
        ',' => {
          pending_comma = true
          skip_indent = false
        }
        '\n' => skip_indent = true
        ' ' | '\t' if skip_indent => ()
        '}' | ']' | ')' => {
          pending_comma = false
          skip_indent = false
          sb.write_char(ch)
        }
        _ => {
          if pending_comma {
            sb.write_string(", ")
            pending_comma = false
          }
          skip_indent = false
          sb.write_char(ch)
        }
      }
    }
  }
  if pending_comma {
    sb.write_char(',')
  }
  sb.to_string()
}

///|
pub impl Show for LexError with output(self, logger) {
  logger.write_string(compact_debug_string(@debug.to_string(self)))
}

///|
pub impl Show for Token with output(self, logger) {
  logger.write_string(compact_debug_string(@debug.to_string(self)))
}

///|
pub impl Show for TokenKind with output(self, logger) {
  logger.write_string(compact_debug_string(@debug.to_string(self)))
}
