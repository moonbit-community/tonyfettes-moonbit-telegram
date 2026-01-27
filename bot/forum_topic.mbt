///|
pub struct ForumTopic {
  message_thread_id : Int
  name : String
  icon_color : Int
  icon_custom_emoji_id : String?
} derive(Show, Eq)

///|
pub fn ForumTopic::new(
  message_thread_id~ : Int,
  name~ : String,
  icon_color~ : Int,
  icon_custom_emoji_id? : String,
) -> ForumTopic {
  { message_thread_id, name, icon_color, icon_custom_emoji_id }
}

///|
pub impl @json.ToJson for ForumTopic with to_json(self) {
  let object : Map[String, Json] = {
    "message_thread_id": @json.to_json(self.message_thread_id),
    "name": @json.to_json(self.name),
    "icon_color": @json.to_json(self.icon_color),
  }
  if self.icon_custom_emoji_id is Some(v) {
    object["icon_custom_emoji_id"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ForumTopic with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForumTopic")
  }
  let message_thread_id : Int = @json.from_json(
    object["message_thread_id"],
    path~,
  )
  let name : String = @json.from_json(object["name"], path~)
  let icon_color : Int = @json.from_json(object["icon_color"], path~)
  let icon_custom_emoji_id : String? = if object.get("icon_custom_emoji_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { message_thread_id, name, icon_color, icon_custom_emoji_id }
}

///|
pub struct ForumTopicCreated {
  name : String
  icon_color : Int
  icon_custom_emoji_id : String?
} derive(Show, Eq)

///|
pub fn ForumTopicCreated::new(
  name~ : String,
  icon_color~ : Int,
  icon_custom_emoji_id? : String,
) -> ForumTopicCreated {
  { name, icon_color, icon_custom_emoji_id }
}

///|
pub impl @json.ToJson for ForumTopicCreated with to_json(self) {
  let object : Map[String, Json] = {
    "name": @json.to_json(self.name),
    "icon_color": @json.to_json(self.icon_color),
  }
  if self.icon_custom_emoji_id is Some(v) {
    object["icon_custom_emoji_id"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ForumTopicCreated with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForumTopicCreated")
  }
  let name : String = @json.from_json(object["name"], path~)
  let icon_color : Int = @json.from_json(object["icon_color"], path~)
  let icon_custom_emoji_id : String? = if object.get("icon_custom_emoji_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { name, icon_color, icon_custom_emoji_id }
}

///|
pub struct ForumTopicEdited {
  name : String?
  icon_custom_emoji_id : String?
} derive(Show, Eq)

///|
pub fn ForumTopicEdited::new(
  name? : String,
  icon_custom_emoji_id? : String,
) -> ForumTopicEdited {
  { name, icon_custom_emoji_id }
}

///|
pub impl @json.ToJson for ForumTopicEdited with to_json(self) {
  let object : Map[String, Json] = {}
  if self.name is Some(v) {
    object["name"] = @json.to_json(v)
  }
  if self.icon_custom_emoji_id is Some(v) {
    object["icon_custom_emoji_id"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ForumTopicEdited with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForumTopicEdited")
  }
  let name : String? = if object.get("name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let icon_custom_emoji_id : String? = if object.get("icon_custom_emoji_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { name, icon_custom_emoji_id }
}
