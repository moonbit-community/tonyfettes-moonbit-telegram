///|
pub struct InlineKeyboardButton {
  text : String
  url : String?
  callback_data : String?
} derive(Show, Eq)

///|
pub fn InlineKeyboardButton::new(
  text~ : String,
  url? : String,
  callback_data? : String,
) -> InlineKeyboardButton {
  { text, url, callback_data }
}

///|
pub impl ToJson for InlineKeyboardButton with to_json(self) {
  let obj : Map[String, Json] = { "text": self.text.to_json() }
  if self.url is Some(v) {
    obj["url"] = v.to_json()
  }
  if self.callback_data is Some(v) {
    obj["callback_data"] = v.to_json()
  }
  obj.to_json()
}

///|
pub impl @json.FromJson for InlineKeyboardButton with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      (path, "Expected object for InlineKeyboardButton"),
    )
  }
  let text : String = @json.from_json(obj["text"], path~)
  let url : String? = if obj.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let callback_data : String? = if obj.get("callback_data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, url, callback_data }
}

///|
pub struct InlineKeyboardMarkup {
  inline_keyboard : Array[Array[InlineKeyboardButton]]
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn InlineKeyboardMarkup::new(
  inline_keyboard~ : Array[Array[InlineKeyboardButton]],
) -> InlineKeyboardMarkup {
  { inline_keyboard, }
}
