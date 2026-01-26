///|
pub struct CallbackQuery {
  id : String
  from : User
  message : Message?
  inline_message_id : String?
  chat_instance : String
  data : String?
} derive(Show, Eq)

///|
pub fn CallbackQuery::new(
  id~ : String,
  from~ : User,
  message? : Message,
  inline_message_id? : String,
  chat_instance~ : String,
  data? : String,
) -> CallbackQuery {
  { id, from, message, inline_message_id, chat_instance, data }
}

///|
pub impl @json.ToJson for CallbackQuery with to_json(self) {
  let obj : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "from": @json.to_json(self.from),
    "chat_instance": @json.to_json(self.chat_instance),
  }
  if self.message is Some(v) {
    obj["message"] = @json.to_json(v)
  }
  if self.inline_message_id is Some(v) {
    obj["inline_message_id"] = @json.to_json(v)
  }
  if self.data is Some(v) {
    obj["data"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for CallbackQuery with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for CallbackQuery")
  }
  let id : String = @json.from_json(object["id"], path~)
  let from : User = @json.from_json(object["from"], path~)
  let message : Message? = if object.get("message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let inline_message_id : String? = if object.get("inline_message_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_instance : String = @json.from_json(object["chat_instance"], path~)
  let data : String? = if object.get("data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, from, message, inline_message_id, chat_instance, data }
}
