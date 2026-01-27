///|
pub struct ReplyKeyboardMarkup {
  keyboard : Array[Array[KeyboardButton]]
  is_persistent : Bool?
  resize_keyboard : Bool?
  one_time_keyboard : Bool?
  input_field_placeholder : String?
  selective : Bool?
} derive(Show, Eq)

///|
pub fn ReplyKeyboardMarkup::new(
  keyboard~ : Array[Array[KeyboardButton]],
  is_persistent? : Bool,
  resize_keyboard? : Bool,
  one_time_keyboard? : Bool,
  input_field_placeholder? : String,
  selective? : Bool,
) -> ReplyKeyboardMarkup {
  {
    keyboard,
    is_persistent,
    resize_keyboard,
    one_time_keyboard,
    input_field_placeholder,
    selective,
  }
}

///|
pub impl @json.ToJson for ReplyKeyboardMarkup with to_json(self) {
  let obj : Map[String, Json] = {
    "keyboard": @json.ToJson::to_json(self.keyboard),
  }
  if self.is_persistent is Some(v) {
    obj["is_persistent"] = @json.to_json(v)
  }
  if self.resize_keyboard is Some(v) {
    obj["resize_keyboard"] = @json.to_json(v)
  }
  if self.one_time_keyboard is Some(v) {
    obj["one_time_keyboard"] = @json.to_json(v)
  }
  if self.input_field_placeholder is Some(v) {
    obj["input_field_placeholder"] = @json.to_json(v)
  }
  if self.selective is Some(v) {
    obj["selective"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ReplyKeyboardMarkup with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ReplyKeyboardMarkup",
    )
  }
  let keyboard : Array[Array[KeyboardButton]] = @json.from_json(
    obj["keyboard"],
    path~,
  )
  let is_persistent : Bool? = if obj.get("is_persistent") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let resize_keyboard : Bool? = if obj.get("resize_keyboard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let one_time_keyboard : Bool? = if obj.get("one_time_keyboard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_field_placeholder : String? = if obj.get("input_field_placeholder")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let selective : Bool? = if obj.get("selective") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    keyboard,
    is_persistent,
    resize_keyboard,
    one_time_keyboard,
    input_field_placeholder,
    selective,
  }
}

///|
pub struct ReplyKeyboardRemove {
  remove_keyboard : Bool
  selective : Bool?
} derive(Show, Eq)

///|
pub fn ReplyKeyboardRemove::new(
  remove_keyboard~ : Bool,
  selective? : Bool,
) -> ReplyKeyboardRemove {
  { remove_keyboard, selective }
}

///|
pub impl @json.ToJson for ReplyKeyboardRemove with to_json(self) {
  let obj : Map[String, Json] = {
    "remove_keyboard": @json.to_json(self.remove_keyboard),
  }
  if self.selective is Some(v) {
    obj["selective"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ReplyKeyboardRemove with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ReplyKeyboardRemove",
    )
  }
  let remove_keyboard : Bool = @json.from_json(obj["remove_keyboard"], path~)
  let selective : Bool? = if obj.get("selective") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { remove_keyboard, selective }
}

///|
pub struct ForceReply {
  force_reply : Bool
  input_field_placeholder : String?
  selective : Bool?
} derive(Show, Eq)

///|
pub fn ForceReply::new(
  force_reply~ : Bool,
  input_field_placeholder? : String,
  selective? : Bool,
) -> ForceReply {
  { force_reply, input_field_placeholder, selective }
}

///|
pub impl @json.ToJson for ForceReply with to_json(self) {
  let obj : Map[String, Json] = {
    "force_reply": @json.to_json(self.force_reply),
  }
  if self.input_field_placeholder is Some(v) {
    obj["input_field_placeholder"] = @json.to_json(v)
  }
  if self.selective is Some(v) {
    obj["selective"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ForceReply with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForceReply")
  }
  let force_reply : Bool = @json.from_json(obj["force_reply"], path~)
  let input_field_placeholder : String? = if obj.get("input_field_placeholder")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let selective : Bool? = if obj.get("selective") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { force_reply, input_field_placeholder, selective }
}
