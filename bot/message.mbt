///|
pub struct MessageEntity {
  type_ : String
  offset : Int
  length : Int
  url : String?
  user : User?
  language : String?
} derive(Debug, Eq)

///|
pub fn MessageEntity::new(
  type_~ : String,
  offset~ : Int,
  length~ : Int,
  url? : String,
  user? : User,
  language? : String,
) -> MessageEntity {
  { type_, offset, length, url, user, language }
}

///|
pub impl @json.ToJson for MessageEntity with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "offset": @json.to_json(self.offset),
    "length": @json.to_json(self.length),
  }
  if self.url is Some(v) {
    object["url"] = @json.to_json(v)
  }
  if self.user is Some(v) {
    object["user"] = @json.to_json(v)
  }
  if self.language is Some(v) {
    object["language"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for MessageEntity with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for MessageEntity")
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let offset : Int = @json.from_json(object["offset"], path~)
  let length : Int = @json.from_json(object["length"], path~)
  let url : String? = if object.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user : User? = if object.get("user") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let language : String? = if object.get("language") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, offset, length, url, user, language }
}

///|
pub struct Message {
  message_id : Int
  from : User?
  date : Int
  chat : Chat
  text : String?
  entities : Array[MessageEntity]?
  reply_to_message : Message?
  message_thread_id : Int?
  is_topic_message : Bool?
  direct_messages_topic : DirectMessagesTopic?
  gift_upgrade_sent : GiftInfo?
  gift_id : String?
  is_from_blockchain : Bool?
} derive(Debug, Eq)

///|
pub fn Message::new(
  message_id~ : Int,
  from? : User,
  date~ : Int,
  chat~ : Chat,
  text? : String,
  entities? : Array[MessageEntity],
  reply_to_message? : Message,
  message_thread_id? : Int,
  is_topic_message? : Bool,
  direct_messages_topic? : DirectMessagesTopic,
  gift_upgrade_sent? : GiftInfo,
  gift_id? : String,
  is_from_blockchain? : Bool,
) -> Message {
  {
    message_id,
    from,
    date,
    chat,
    text,
    entities,
    reply_to_message,
    message_thread_id,
    is_topic_message,
    direct_messages_topic,
    gift_upgrade_sent,
    gift_id,
    is_from_blockchain,
  }
}

///|
pub impl @json.ToJson for Message with to_json(self) {
  let object : Map[String, Json] = {
    "message_id": @json.to_json(self.message_id),
    "date": @json.to_json(self.date),
    "chat": @json.to_json(self.chat),
  }
  if self.from is Some(v) {
    object["from"] = @json.to_json(v)
  }
  if self.text is Some(v) {
    object["text"] = @json.to_json(v)
  }
  if self.entities is Some(v) {
    object["entities"] = @json.to_json(v)
  }
  if self.reply_to_message is Some(v) {
    object["reply_to_message"] = @json.to_json(v)
  }
  if self.message_thread_id is Some(v) {
    object["message_thread_id"] = @json.to_json(v)
  }
  if self.is_topic_message is Some(v) {
    object["is_topic_message"] = @json.to_json(v)
  }
  if self.direct_messages_topic is Some(v) {
    object["direct_messages_topic"] = @json.to_json(v)
  }
  if self.gift_upgrade_sent is Some(v) {
    object["gift_upgrade_sent"] = @json.to_json(v)
  }
  if self.gift_id is Some(v) {
    object["gift_id"] = @json.to_json(v)
  }
  if self.is_from_blockchain is Some(v) {
    object["is_from_blockchain"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Message with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Message")
  }
  let message_id : Int = @json.from_json(object["message_id"], path~)
  let from : User? = if object.get("from") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let date : Int = @json.from_json(object["date"], path~)
  let chat : Chat = @json.from_json(object["chat"], path~)
  let text : String? = if object.get("text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if object.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_to_message : Message? = if object.get("reply_to_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message_thread_id : Int? = if object.get("message_thread_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_topic_message : Bool? = if object.get("is_topic_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let direct_messages_topic : DirectMessagesTopic? = if object.get(
      "direct_messages_topic",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gift_upgrade_sent : GiftInfo? = if object.get("gift_upgrade_sent")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gift_id : String? = if object.get("gift_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_from_blockchain : Bool? = if object.get("is_from_blockchain")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    message_id,
    from,
    date,
    chat,
    text,
    entities,
    reply_to_message,
    message_thread_id,
    is_topic_message,
    direct_messages_topic,
    gift_upgrade_sent,
    gift_id,
    is_from_blockchain,
  }
}
