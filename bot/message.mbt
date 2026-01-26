///|
pub(all) struct MessageEntity {
  type_ : String
  offset : Int
  length : Int
  url : String?
  user : User?
  language : String?
} derive(Show, Eq)

///|
pub impl ToJson for MessageEntity with to_json(self) {
  let obj : Map[String, Json] = {
    "type": self.type_.to_json(),
    "offset": self.offset.to_json(),
    "length": self.length.to_json(),
  }
  if self.url is Some(v) {
    obj["url"] = v.to_json()
  }
  if self.user is Some(v) {
    obj["user"] = v.to_json()
  }
  if self.language is Some(v) {
    obj["language"] = v.to_json()
  }
  obj.to_json()
}

///|
pub impl @json.FromJson for MessageEntity with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError((path, "Expected object for MessageEntity"))
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let offset : Int = @json.from_json(obj["offset"], path~)
  let length : Int = @json.from_json(obj["length"], path~)
  let url : String? = if obj.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user : User? = if obj.get("user") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let language : String? = if obj.get("language") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, offset, length, url, user, language }
}

///|
pub(all) struct Message {
  message_id : Int
  from : User?
  date : Int
  chat : Chat
  text : String?
  entities : Array[MessageEntity]?
  reply_to_message : Message?
} derive(Show, Eq)

///|
pub impl ToJson for Message with to_json(self) {
  let obj : Map[String, Json] = {
    "message_id": self.message_id.to_json(),
    "date": self.date.to_json(),
    "chat": self.chat.to_json(),
  }
  if self.from is Some(v) {
    obj["from"] = v.to_json()
  }
  if self.text is Some(v) {
    obj["text"] = v.to_json()
  }
  if self.entities is Some(v) {
    obj["entities"] = v.to_json()
  }
  if self.reply_to_message is Some(v) {
    obj["reply_to_message"] = v.to_json()
  }
  obj.to_json()
}

///|
pub impl @json.FromJson for Message with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError((path, "Expected object for Message"))
  }
  let message_id : Int = @json.from_json(obj["message_id"], path~)
  let from : User? = if obj.get("from") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let date : Int = @json.from_json(obj["date"], path~)
  let chat : Chat = @json.from_json(obj["chat"], path~)
  let text : String? = if obj.get("text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if obj.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_to_message : Message? = if obj.get("reply_to_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { message_id, from, date, chat, text, entities, reply_to_message }
}
