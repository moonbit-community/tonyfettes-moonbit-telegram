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
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendMessage")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "text": @json.to_json(text),
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if reply_to_message_id is Some(v) {
    body["reply_to_message_id"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
    body["offset"] = @json.to_json(v)
  }
  if limit is Some(v) {
    body["limit"] = @json.to_json(v)
  }
  if timeout is Some(v) {
    body["timeout"] = @json.to_json(v)
  }
  if allowed_updates is Some(v) {
    body["allowed_updates"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to copy messages of any kind.
/// Returns the MessageId of the sent message on success.
pub async fn Bot::copy_message(
  self : Bot,
  chat_id~ : Int64,
  from_chat_id~ : Int64,
  message_id~ : Int,
  disable_notification? : Bool,
  reply_markup? : InlineKeyboardMarkup,
) -> MessageId raise TelegramError {
  let url = self.api_url("copyMessage")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "from_chat_id": @json.to_json(from_chat_id),
    "message_id": @json.to_json(message_id),
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to edit text and game messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_text(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
  text~ : String,
  parse_mode? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageText")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "message_id": @json.to_json(message_id),
    "text": @json.to_json(text),
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to edit only the reply markup of messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_reply_markup(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageReplyMarkup")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "message_id": @json.to_json(message_id),
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send answers to callback queries sent from inline keyboards.
/// On success, True is returned.
pub async fn Bot::answer_callback_query(
  self : Bot,
  callback_query_id~ : String,
  text? : String,
  show_alert? : Bool,
) -> Bool raise TelegramError {
  let url = self.api_url("answerCallbackQuery")
  let body : Map[String, Json] = {
    "callback_query_id": @json.to_json(callback_query_id),
  }
  if text is Some(v) {
    body["text"] = @json.to_json(v)
  }
  if show_alert is Some(v) {
    body["show_alert"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to change the list of the bot's commands.
/// On success, True is returned.
pub async fn Bot::set_my_commands(
  self : Bot,
  commands~ : Array[BotCommand],
) -> Bool raise TelegramError {
  let url = self.api_url("setMyCommands")
  let body : Map[String, Json] = { "commands": @json.ToJson::to_json(commands) }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send photos.
/// On success, the sent Message is returned.
pub async fn Bot::send_photo(
  self : Bot,
  chat_id~ : Int64,
  photo~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendPhoto")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "photo": @json.to_json(photo),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = @json.to_json(v)
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send video files.
/// On success, the sent Message is returned.
pub async fn Bot::send_video(
  self : Bot,
  chat_id~ : Int64,
  video~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  width? : Int,
  height? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  supports_streaming? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVideo")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "video": @json.to_json(video),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = @json.to_json(v)
  }
  if width is Some(v) {
    body["width"] = @json.to_json(v)
  }
  if height is Some(v) {
    body["height"] = @json.to_json(v)
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = @json.to_json(v)
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = @json.to_json(v)
  }
  if supports_streaming is Some(v) {
    body["supports_streaming"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send audio files, if you want Telegram clients to display
/// them in the music player. Your audio must be in the .MP3 or .M4A format.
/// On success, the sent Message is returned.
pub async fn Bot::send_audio(
  self : Bot,
  chat_id~ : Int64,
  audio~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  duration? : Int,
  performer? : String,
  title? : String,
  thumbnail? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendAudio")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "audio": @json.to_json(audio),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = @json.to_json(v)
  }
  if performer is Some(v) {
    body["performer"] = @json.to_json(v)
  }
  if title is Some(v) {
    body["title"] = @json.to_json(v)
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send general files.
/// On success, the sent Message is returned.
pub async fn Bot::send_document(
  self : Bot,
  chat_id~ : Int64,
  document~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  disable_content_type_detection? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendDocument")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "document": @json.to_json(document),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if disable_content_type_detection is Some(v) {
    body["disable_content_type_detection"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send voice messages.
/// On success, the sent Message is returned.
pub async fn Bot::send_voice(
  self : Bot,
  chat_id~ : Int64,
  voice~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  duration? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVoice")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "voice": @json.to_json(voice),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send video messages (video notes).
/// On success, the sent Message is returned.
pub async fn Bot::send_video_note(
  self : Bot,
  chat_id~ : Int64,
  video_note~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  length? : Int,
  thumbnail? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVideoNote")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "video_note": @json.to_json(video_note),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = @json.to_json(v)
  }
  if length is Some(v) {
    body["length"] = @json.to_json(v)
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send animation files (GIF or H.264/MPEG-4 AVC video without sound).
/// On success, the sent Message is returned.
pub async fn Bot::send_animation(
  self : Bot,
  chat_id~ : Int64,
  animation~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  duration? : Int,
  width? : Int,
  height? : Int,
  thumbnail? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  has_spoiler? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendAnimation")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "animation": @json.to_json(animation),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if duration is Some(v) {
    body["duration"] = @json.to_json(v)
  }
  if width is Some(v) {
    body["width"] = @json.to_json(v)
  }
  if height is Some(v) {
    body["height"] = @json.to_json(v)
  }
  if thumbnail is Some(v) {
    body["thumbnail"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = @json.to_json(v)
  }
  if has_spoiler is Some(v) {
    body["has_spoiler"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send point on the map.
/// On success, the sent Message is returned.
pub async fn Bot::send_location(
  self : Bot,
  chat_id~ : Int64,
  latitude~ : Double,
  longitude~ : Double,
  business_connection_id? : String,
  message_thread_id? : Int,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendLocation")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "latitude": @json.to_json(latitude),
    "longitude": @json.to_json(longitude),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if horizontal_accuracy is Some(v) {
    body["horizontal_accuracy"] = @json.to_json(v)
  }
  if live_period is Some(v) {
    body["live_period"] = @json.to_json(v)
  }
  if heading is Some(v) {
    body["heading"] = @json.to_json(v)
  }
  if proximity_alert_radius is Some(v) {
    body["proximity_alert_radius"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send information about a venue.
/// On success, the sent Message is returned.
pub async fn Bot::send_venue(
  self : Bot,
  chat_id~ : Int64,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendVenue")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "latitude": @json.to_json(latitude),
    "longitude": @json.to_json(longitude),
    "title": @json.to_json(title),
    "address": @json.to_json(address),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if foursquare_id is Some(v) {
    body["foursquare_id"] = @json.to_json(v)
  }
  if foursquare_type is Some(v) {
    body["foursquare_type"] = @json.to_json(v)
  }
  if google_place_id is Some(v) {
    body["google_place_id"] = @json.to_json(v)
  }
  if google_place_type is Some(v) {
    body["google_place_type"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send phone contacts.
/// On success, the sent Message is returned.
pub async fn Bot::send_contact(
  self : Bot,
  chat_id~ : Int64,
  phone_number~ : String,
  first_name~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
  last_name? : String,
  vcard? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendContact")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "phone_number": @json.to_json(phone_number),
    "first_name": @json.to_json(first_name),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if last_name is Some(v) {
    body["last_name"] = @json.to_json(v)
  }
  if vcard is Some(v) {
    body["vcard"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send a native poll.
/// On success, the sent Message is returned.
pub async fn Bot::send_poll(
  self : Bot,
  chat_id~ : Int64,
  question~ : String,
  options~ : Array[InputPollOption],
  business_connection_id? : String,
  message_thread_id? : Int,
  question_parse_mode? : String,
  question_entities? : Array[MessageEntity],
  is_anonymous? : Bool,
  type_? : String,
  allows_multiple_answers? : Bool,
  correct_option_id? : Int,
  explanation? : String,
  explanation_parse_mode? : String,
  explanation_entities? : Array[MessageEntity],
  open_period? : Int,
  close_date? : Int,
  is_closed? : Bool,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendPoll")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "question": @json.to_json(question),
    "options": @json.ToJson::to_json(options),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if question_parse_mode is Some(v) {
    body["question_parse_mode"] = @json.to_json(v)
  }
  if question_entities is Some(v) {
    body["question_entities"] = @json.ToJson::to_json(v)
  }
  if is_anonymous is Some(v) {
    body["is_anonymous"] = @json.to_json(v)
  }
  if type_ is Some(v) {
    body["type"] = @json.to_json(v)
  }
  if allows_multiple_answers is Some(v) {
    body["allows_multiple_answers"] = @json.to_json(v)
  }
  if correct_option_id is Some(v) {
    body["correct_option_id"] = @json.to_json(v)
  }
  if explanation is Some(v) {
    body["explanation"] = @json.to_json(v)
  }
  if explanation_parse_mode is Some(v) {
    body["explanation_parse_mode"] = @json.to_json(v)
  }
  if explanation_entities is Some(v) {
    body["explanation_entities"] = @json.ToJson::to_json(v)
  }
  if open_period is Some(v) {
    body["open_period"] = @json.to_json(v)
  }
  if close_date is Some(v) {
    body["close_date"] = @json.to_json(v)
  }
  if is_closed is Some(v) {
    body["is_closed"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to send an animated emoji that will display a random value.
/// On success, the sent Message is returned.
pub async fn Bot::send_dice(
  self : Bot,
  chat_id~ : Int64,
  business_connection_id? : String,
  message_thread_id? : Int,
  emoji? : String,
  disable_notification? : Bool,
  protect_content? : Bool,
  allow_paid_broadcast? : Bool,
  message_effect_id? : String,
  reply_parameters? : ReplyParameters,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("sendDice")
  let body : Map[String, Json] = { "chat_id": @json.to_json(chat_id) }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  if emoji is Some(v) {
    body["emoji"] = @json.to_json(v)
  }
  if disable_notification is Some(v) {
    body["disable_notification"] = @json.to_json(v)
  }
  if protect_content is Some(v) {
    body["protect_content"] = @json.to_json(v)
  }
  if allow_paid_broadcast is Some(v) {
    body["allow_paid_broadcast"] = @json.to_json(v)
  }
  if message_effect_id is Some(v) {
    body["message_effect_id"] = @json.to_json(v)
  }
  if reply_parameters is Some(v) {
    body["reply_parameters"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method when you need to tell the user that something is happening on the bot's side.
/// The status is set for 5 seconds or less (when a message arrives from your bot, Telegram clients clear its typing status).
/// On success, True is returned.
pub async fn Bot::send_chat_action(
  self : Bot,
  chat_id~ : Int64,
  action~ : String,
  business_connection_id? : String,
  message_thread_id? : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("sendChatAction")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "action": @json.to_json(action),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if message_thread_id is Some(v) {
    body["message_thread_id"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to edit live location messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_live_location(
  self : Bot,
  latitude~ : Double,
  longitude~ : Double,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  live_period? : Int,
  horizontal_accuracy? : Double,
  heading? : Int,
  proximity_alert_radius? : Int,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageLiveLocation")
  let body : Map[String, Json] = {
    "latitude": @json.to_json(latitude),
    "longitude": @json.to_json(longitude),
  }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if chat_id is Some(v) {
    body["chat_id"] = @json.to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = @json.to_json(v)
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = @json.to_json(v)
  }
  if live_period is Some(v) {
    body["live_period"] = @json.to_json(v)
  }
  if horizontal_accuracy is Some(v) {
    body["horizontal_accuracy"] = @json.to_json(v)
  }
  if heading is Some(v) {
    body["heading"] = @json.to_json(v)
  }
  if proximity_alert_radius is Some(v) {
    body["proximity_alert_radius"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to stop updating a live location message before live_period expires.
/// On success, the edited Message is returned.
pub async fn Bot::stop_message_live_location(
  self : Bot,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("stopMessageLiveLocation")
  let body : Map[String, Json] = {}
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if chat_id is Some(v) {
    body["chat_id"] = @json.to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = @json.to_json(v)
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to edit captions of messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_caption(
  self : Bot,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageCaption")
  let body : Map[String, Json] = {}
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if chat_id is Some(v) {
    body["chat_id"] = @json.to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = @json.to_json(v)
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = @json.to_json(v)
  }
  if caption is Some(v) {
    body["caption"] = @json.to_json(v)
  }
  if parse_mode is Some(v) {
    body["parse_mode"] = @json.to_json(v)
  }
  if caption_entities is Some(v) {
    body["caption_entities"] = @json.ToJson::to_json(v)
  }
  if show_caption_above_media is Some(v) {
    body["show_caption_above_media"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to edit animation, audio, document, photo, or video messages.
/// On success, the edited Message is returned.
pub async fn Bot::edit_message_media(
  self : Bot,
  media~ : Json,
  business_connection_id? : String,
  chat_id? : Int64,
  message_id? : Int,
  inline_message_id? : String,
  reply_markup? : InlineKeyboardMarkup,
) -> Message raise TelegramError {
  let url = self.api_url("editMessageMedia")
  let body : Map[String, Json] = { "media": media }
  if business_connection_id is Some(v) {
    body["business_connection_id"] = @json.to_json(v)
  }
  if chat_id is Some(v) {
    body["chat_id"] = @json.to_json(v)
  }
  if message_id is Some(v) {
    body["message_id"] = @json.to_json(v)
  }
  if inline_message_id is Some(v) {
    body["inline_message_id"] = @json.to_json(v)
  }
  if reply_markup is Some(v) {
    body["reply_markup"] = @json.to_json(v)
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to delete a message, including service messages.
/// Returns True on success.
pub async fn Bot::delete_message(
  self : Bot,
  chat_id~ : Int64,
  message_id~ : Int,
) -> Bool raise TelegramError {
  let url = self.api_url("deleteMessage")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "message_id": @json.to_json(message_id),
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
/// Use this method to delete multiple messages simultaneously.
/// Returns True on success.
pub async fn Bot::delete_messages(
  self : Bot,
  chat_id~ : Int64,
  message_ids~ : Array[Int],
) -> Bool raise TelegramError {
  let url = self.api_url("deleteMessages")
  let body : Map[String, Json] = {
    "chat_id": @json.to_json(chat_id),
    "message_ids": @json.ToJson::to_json(message_ids),
  }
  let (response, data) = @http.post(url, @json.to_json(body), headers={
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
