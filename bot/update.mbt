///|
pub struct Update {
  update_id : Int
  message : Message?
  edited_message : Message?
  callback_query : CallbackQuery?
} derive(Show, Eq)

///|
pub fn Update::new(
  update_id~ : Int,
  message? : Message,
  edited_message? : Message,
  callback_query? : CallbackQuery,
) -> Update {
  { update_id, message, edited_message, callback_query }
}

///|
pub impl @json.ToJson for Update with to_json(self) {
  let object : Map[String, Json] = { "update_id": @json.to_json(self.update_id) }
  if self.message is Some(v) {
    object["message"] = @json.to_json(v)
  }
  if self.edited_message is Some(v) {
    object["edited_message"] = @json.to_json(v)
  }
  if self.callback_query is Some(v) {
    object["callback_query"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Update with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Update")
  }
  let update_id : Int = @json.from_json(object["update_id"], path~)
  let message : Message? = if object.get("message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let edited_message : Message? = if object.get("edited_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let callback_query : CallbackQuery? = if object.get("callback_query")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { update_id, message, edited_message, callback_query }
}
