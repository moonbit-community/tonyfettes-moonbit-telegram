///|
pub struct LoginUrl {
  url : String
  forward_text : String?
  bot_username : String?
  request_write_access : Bool?
} derive(Show, Eq)

///|
pub fn LoginUrl::new(
  url~ : String,
  forward_text? : String,
  bot_username? : String,
  request_write_access? : Bool,
) -> LoginUrl {
  { url, forward_text, bot_username, request_write_access }
}

///|
pub impl @json.ToJson for LoginUrl with to_json(self) {
  let obj : Map[String, Json] = { "url": @json.to_json(self.url) }
  if self.forward_text is Some(v) {
    obj["forward_text"] = @json.to_json(v)
  }
  if self.bot_username is Some(v) {
    obj["bot_username"] = @json.to_json(v)
  }
  if self.request_write_access is Some(v) {
    obj["request_write_access"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for LoginUrl with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for LoginUrl")
  }
  let url : String = @json.from_json(obj["url"], path~)
  let forward_text : String? = if obj.get("forward_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let bot_username : String? = if obj.get("bot_username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let request_write_access : Bool? = if obj.get("request_write_access")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { url, forward_text, bot_username, request_write_access }
}

///|
pub struct SwitchInlineQueryChosenChat {
  query : String?
  allow_user_chats : Bool?
  allow_bot_chats : Bool?
  allow_group_chats : Bool?
  allow_channel_chats : Bool?
} derive(Show, Eq)

///|
pub fn SwitchInlineQueryChosenChat::new(
  query? : String,
  allow_user_chats? : Bool,
  allow_bot_chats? : Bool,
  allow_group_chats? : Bool,
  allow_channel_chats? : Bool,
) -> SwitchInlineQueryChosenChat {
  {
    query,
    allow_user_chats,
    allow_bot_chats,
    allow_group_chats,
    allow_channel_chats,
  }
}

///|
pub impl @json.ToJson for SwitchInlineQueryChosenChat with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.query is Some(v) {
    obj["query"] = @json.to_json(v)
  }
  if self.allow_user_chats is Some(v) {
    obj["allow_user_chats"] = @json.to_json(v)
  }
  if self.allow_bot_chats is Some(v) {
    obj["allow_bot_chats"] = @json.to_json(v)
  }
  if self.allow_group_chats is Some(v) {
    obj["allow_group_chats"] = @json.to_json(v)
  }
  if self.allow_channel_chats is Some(v) {
    obj["allow_channel_chats"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for SwitchInlineQueryChosenChat with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for SwitchInlineQueryChosenChat",
    )
  }
  let query : String? = if obj.get("query") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_user_chats : Bool? = if obj.get("allow_user_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_bot_chats : Bool? = if obj.get("allow_bot_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_group_chats : Bool? = if obj.get("allow_group_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_channel_chats : Bool? = if obj.get("allow_channel_chats") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    query,
    allow_user_chats,
    allow_bot_chats,
    allow_group_chats,
    allow_channel_chats,
  }
}

///|
pub struct CallbackGame {} derive(Show, Eq)

///|
pub fn CallbackGame::new() -> CallbackGame {
  CallbackGame::{  }
}

///|
pub impl @json.ToJson for CallbackGame with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for CallbackGame with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(path~, "Expected object for CallbackGame")
  }
  CallbackGame::{  }
}
