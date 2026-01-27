///|
pub struct WebAppInfo {
  url : String
} derive(Show, Eq)

///|
pub fn WebAppInfo::new(url~ : String) -> WebAppInfo {
  { url, }
}

///|
pub impl @json.ToJson for WebAppInfo with to_json(self) {
  let obj : Map[String, Json] = { "url": @json.to_json(self.url) }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for WebAppInfo with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for WebAppInfo")
  }
  let url : String = @json.from_json(obj["url"], path~)
  { url, }
}

///|
pub struct KeyboardButtonPollType {
  type_ : String?
} derive(Show, Eq)

///|
pub fn KeyboardButtonPollType::new(type_? : String) -> KeyboardButtonPollType {
  { type_, }
}

///|
pub impl @json.ToJson for KeyboardButtonPollType with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.type_ is Some(v) {
    obj["type"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for KeyboardButtonPollType with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for KeyboardButtonPollType",
    )
  }
  let type_ : String? = if obj.get("type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, }
}

///|
pub struct KeyboardButtonRequestUsers {
  request_id : Int
  user_is_bot : Bool?
  user_is_premium : Bool?
  max_quantity : Int?
  request_name : Bool?
  request_username : Bool?
  request_photo : Bool?
} derive(Show, Eq)

///|
pub fn KeyboardButtonRequestUsers::new(
  request_id~ : Int,
  user_is_bot? : Bool,
  user_is_premium? : Bool,
  max_quantity? : Int,
  request_name? : Bool,
  request_username? : Bool,
  request_photo? : Bool,
) -> KeyboardButtonRequestUsers {
  {
    request_id,
    user_is_bot,
    user_is_premium,
    max_quantity,
    request_name,
    request_username,
    request_photo,
  }
}

///|
pub impl @json.ToJson for KeyboardButtonRequestUsers with to_json(self) {
  let obj : Map[String, Json] = { "request_id": @json.to_json(self.request_id) }
  if self.user_is_bot is Some(v) {
    obj["user_is_bot"] = @json.to_json(v)
  }
  if self.user_is_premium is Some(v) {
    obj["user_is_premium"] = @json.to_json(v)
  }
  if self.max_quantity is Some(v) {
    obj["max_quantity"] = @json.to_json(v)
  }
  if self.request_name is Some(v) {
    obj["request_name"] = @json.to_json(v)
  }
  if self.request_username is Some(v) {
    obj["request_username"] = @json.to_json(v)
  }
  if self.request_photo is Some(v) {
    obj["request_photo"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for KeyboardButtonRequestUsers with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for KeyboardButtonRequestUsers",
    )
  }
  let request_id : Int = @json.from_json(obj["request_id"], path~)
  let user_is_bot : Bool? = if obj.get("user_is_bot") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user_is_premium : Bool? = if obj.get("user_is_premium") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let max_quantity : Int? = if obj.get("max_quantity") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_name : Bool? = if obj.get("request_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_username : Bool? = if obj.get("request_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_photo : Bool? = if obj.get("request_photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    request_id,
    user_is_bot,
    user_is_premium,
    max_quantity,
    request_name,
    request_username,
    request_photo,
  }
}

///|
pub struct KeyboardButtonRequestChat {
  request_id : Int
  chat_is_channel : Bool
  chat_is_forum : Bool?
  chat_has_username : Bool?
  chat_is_created : Bool?
  bot_is_member : Bool?
  request_title : Bool?
  request_username : Bool?
  request_photo : Bool?
} derive(Show, Eq)

///|
pub fn KeyboardButtonRequestChat::new(
  request_id~ : Int,
  chat_is_channel~ : Bool,
  chat_is_forum? : Bool,
  chat_has_username? : Bool,
  chat_is_created? : Bool,
  bot_is_member? : Bool,
  request_title? : Bool,
  request_username? : Bool,
  request_photo? : Bool,
) -> KeyboardButtonRequestChat {
  {
    request_id,
    chat_is_channel,
    chat_is_forum,
    chat_has_username,
    chat_is_created,
    bot_is_member,
    request_title,
    request_username,
    request_photo,
  }
}

///|
pub impl @json.ToJson for KeyboardButtonRequestChat with to_json(self) {
  let obj : Map[String, Json] = {
    "request_id": @json.to_json(self.request_id),
    "chat_is_channel": @json.to_json(self.chat_is_channel),
  }
  if self.chat_is_forum is Some(v) {
    obj["chat_is_forum"] = @json.to_json(v)
  }
  if self.chat_has_username is Some(v) {
    obj["chat_has_username"] = @json.to_json(v)
  }
  if self.chat_is_created is Some(v) {
    obj["chat_is_created"] = @json.to_json(v)
  }
  if self.bot_is_member is Some(v) {
    obj["bot_is_member"] = @json.to_json(v)
  }
  if self.request_title is Some(v) {
    obj["request_title"] = @json.to_json(v)
  }
  if self.request_username is Some(v) {
    obj["request_username"] = @json.to_json(v)
  }
  if self.request_photo is Some(v) {
    obj["request_photo"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for KeyboardButtonRequestChat with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for KeyboardButtonRequestChat",
    )
  }
  let request_id : Int = @json.from_json(obj["request_id"], path~)
  let chat_is_channel : Bool = @json.from_json(obj["chat_is_channel"], path~)
  let chat_is_forum : Bool? = if obj.get("chat_is_forum") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_has_username : Bool? = if obj.get("chat_has_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let chat_is_created : Bool? = if obj.get("chat_is_created") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let bot_is_member : Bool? = if obj.get("bot_is_member") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_title : Bool? = if obj.get("request_title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_username : Bool? = if obj.get("request_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_photo : Bool? = if obj.get("request_photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    request_id,
    chat_is_channel,
    chat_is_forum,
    chat_has_username,
    chat_is_created,
    bot_is_member,
    request_title,
    request_username,
    request_photo,
  }
}

///|
pub struct KeyboardButton {
  text : String
  request_users : KeyboardButtonRequestUsers?
  request_chat : KeyboardButtonRequestChat?
  request_contact : Bool?
  request_location : Bool?
  request_poll : KeyboardButtonPollType?
  web_app : WebAppInfo?
} derive(Show, Eq)

///|
pub fn KeyboardButton::new(
  text~ : String,
  request_users? : KeyboardButtonRequestUsers,
  request_chat? : KeyboardButtonRequestChat,
  request_contact? : Bool,
  request_location? : Bool,
  request_poll? : KeyboardButtonPollType,
  web_app? : WebAppInfo,
) -> KeyboardButton {
  {
    text,
    request_users,
    request_chat,
    request_contact,
    request_location,
    request_poll,
    web_app,
  }
}

///|
pub impl @json.ToJson for KeyboardButton with to_json(self) {
  let obj : Map[String, Json] = { "text": @json.to_json(self.text) }
  if self.request_users is Some(v) {
    obj["request_users"] = @json.to_json(v)
  }
  if self.request_chat is Some(v) {
    obj["request_chat"] = @json.to_json(v)
  }
  if self.request_contact is Some(v) {
    obj["request_contact"] = @json.to_json(v)
  }
  if self.request_location is Some(v) {
    obj["request_location"] = @json.to_json(v)
  }
  if self.request_poll is Some(v) {
    obj["request_poll"] = @json.to_json(v)
  }
  if self.web_app is Some(v) {
    obj["web_app"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for KeyboardButton with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for KeyboardButton")
  }
  let text : String = @json.from_json(obj["text"], path~)
  let request_users : KeyboardButtonRequestUsers? = if obj.get("request_users")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_chat : KeyboardButtonRequestChat? = if obj.get("request_chat")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_contact : Bool? = if obj.get("request_contact") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_location : Bool? = if obj.get("request_location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_poll : KeyboardButtonPollType? = if obj.get("request_poll")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let web_app : WebAppInfo? = if obj.get("web_app") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    text,
    request_users,
    request_chat,
    request_contact,
    request_location,
    request_poll,
    web_app,
  }
}
