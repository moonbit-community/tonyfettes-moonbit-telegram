///|
pub(all) suberror TelegramError {
  HttpError(code~ : Int, body~ : String)
  ApiError(code~ : Int, description~ : String)
  InvalidUtf8(@encoding/utf8.Malformed)
  InvalidJson(@json.ParseError)
  InvalidResponse(Json)
  InvalidResult(Json, @json.JsonDecodeError)
  ParseError(message~ : String)
}

///|
impl Show for TelegramError with output(self : TelegramError, logger : &Logger) -> Unit {
  match self {
    TelegramError::HttpError(code~, body~) =>
      logger.write_string("HttpError(code=\{code}, body=\{body})")
    TelegramError::ApiError(code~, description~) =>
      logger.write_string("ApiError(code=\{code}, description=\{description})")
    TelegramError::InvalidUtf8(@encoding/utf8.Malformed(error)) =>
      logger.write_string(
        "InvalidUtf8(error=@encoding/utf8.Malformed(\{error}))",
      )
    TelegramError::InvalidJson(error) =>
      logger.write_string("InvalidJson(error=\{@debug.to_string(error)})")
    TelegramError::InvalidResponse(json) =>
      logger.write_string("InvalidResponse(json=\{@json.stringify(json)})")
    TelegramError::InvalidResult(json, error) =>
      logger.write_string(
        "InvalidResult(json=\{@json.stringify(json)}, error=\{error})",
      )
    TelegramError::ParseError(message~) =>
      logger.write_string("ParseError(message=\{message})")
  }
}
