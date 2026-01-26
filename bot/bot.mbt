///|
pub struct Bot {
  token : String
  base_url : String
}

///|
pub fn Bot::new(token~ : String, base_url? : String) -> Bot {
  { token, base_url: base_url.unwrap_or("https://api.telegram.org") }
}

///|
fn Bot::api_url(self : Bot, api_method : String) -> String {
  "\{self.base_url}/bot\{self.token}/\{api_method}"
}

///|
fn[T : @json.FromJson] parse_api_response(
  data : &@io.Data,
) -> T raise TelegramError {
  let text = @encoding/utf8.decode(data.binary()) catch {
    error => raise TelegramError::InvalidUtf8(error)
  }
  let json = @json.parse(text) catch {
    error => raise TelegramError::InvalidJson(error)
  }
  guard json is { "ok": true, "result": result, .. } else {
    guard json
      is { "error_code": Number(code, ..), "description": String(desc), .. } else {
      raise TelegramError::InvalidResponse(json)
    }
    raise TelegramError::ApiError(code=code.to_int(), description=desc)
  }
  @json.from_json(result) catch {
    error => raise TelegramError::InvalidResult(result, error)
  }
}

///|
/// A simple method for testing your bot's auth token.
/// Returns basic information about the bot in form of a User object.
pub async fn Bot::get_me(self : Bot) -> User raise TelegramError {
  let url = self.api_url("getMe")
  let (response, data) = @http.get(url, headers={
    "Content-Type": "application/json",
  }) catch {
    error =>
      raise TelegramError::HttpError(code=0, body="Request failed: \{error}")
  }
  guard response.code is (200..=299) else {
    let body = data.text() catch { _ => "<failed to read body>" }
    raise TelegramError::HttpError(code=response.code, body~)
  }
  parse_api_response(data)
}

///|
/// Use this method to send text messages.
/// On success, the sent Message is returned.
pub async fn Bot::send_message(
  self : Bot,
  chat_id~ : Int64,
  text~ : String,
  parse_mode? : String,
  disable_notification? : Bool,
  reply_to_message_id? : Int,
) -> Message raise TelegramError {
  let url = self.api_url("sendMessage")
  let body : Map[String, Json] = {
    "chat_id": chat_id.to_json(),
    "text": text.to_json(),
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = v.to_json()
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = v.to_json()
  }
  if reply_to_message_id is Some(v) {
    body["reply_to_message_id"] = v.to_json()
  }
  let (response, data) = @http.post(url, body.to_json(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let body_text = data.text() catch { _ => "<failed to read body>" }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}

///|
/// Use this method to receive incoming updates using long polling.
/// Returns an Array of Update objects.
pub async fn Bot::get_updates(
  self : Bot,
  offset? : Int,
  limit? : Int,
  timeout? : Int,
  allowed_updates? : Array[String],
) -> Array[Update] raise TelegramError {
  let url = self.api_url("getUpdates")
  let body : Map[String, Json] = {}
  if offset is Some(v) {
    body["offset"] = v.to_json()
  }
  if limit is Some(v) {
    body["limit"] = v.to_json()
  }
  if timeout is Some(v) {
    body["timeout"] = v.to_json()
  }
  if allowed_updates is Some(v) {
    body["allowed_updates"] = v.to_json()
  }
  let (response, data) = @http.post(url, body.to_json(), headers={
    "Content-Type": "application/json",
  }) catch {
    err => raise TelegramError::HttpError(code=0, body="Request failed: \{err}")
  }
  guard response.code is (200..=299) else {
    let body_text = data.text() catch { _ => "<failed to read body>" }
    raise TelegramError::HttpError(code=response.code, body=body_text)
  }
  parse_api_response(data)
}
