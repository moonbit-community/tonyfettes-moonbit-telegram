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
pub impl ToJson for CallbackQuery with to_json(self) {
  let obj : Map[String, Json] = {
    "id": self.id.to_json(),
    "from": self.from.to_json(),
    "chat_instance": self.chat_instance.to_json(),
  }
  if self.message is Some(v) {
    obj["message"] = v.to_json()
  }
  if self.inline_message_id is Some(v) {
    obj["inline_message_id"] = v.to_json()
  }
  if self.data is Some(v) {
    obj["data"] = v.to_json()
  }
  obj.to_json()
}

///|
pub impl @json.FromJson for CallbackQuery with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError((path, "Expected object for CallbackQuery"))
  }
  let id : String = @json.from_json(obj["id"], path~)
  let from : User = @json.from_json(obj["from"], path~)
  let message : Message? = if obj.get("message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let inline_message_id : String? = if obj.get("inline_message_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_instance : String = @json.from_json(obj["chat_instance"], path~)
  let data : String? = if obj.get("data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, from, message, inline_message_id, chat_instance, data }
}
