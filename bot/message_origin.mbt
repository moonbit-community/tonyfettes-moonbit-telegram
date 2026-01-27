///|
pub struct MessageOriginUser {
  date : Int
  sender_user : User
} derive(Show, Eq)

///|
pub fn MessageOriginUser::new(
  date~ : Int,
  sender_user~ : User,
) -> MessageOriginUser {
  { date, sender_user }
}

///|
pub struct MessageOriginHiddenUser {
  date : Int
  sender_user_name : String
} derive(Show, Eq)

///|
pub fn MessageOriginHiddenUser::new(
  date~ : Int,
  sender_user_name~ : String,
) -> MessageOriginHiddenUser {
  { date, sender_user_name }
}

///|
pub struct MessageOriginChat {
  date : Int
  sender_chat : Chat
  author_signature : String?
} derive(Show, Eq)

///|
pub fn MessageOriginChat::new(
  date~ : Int,
  sender_chat~ : Chat,
  author_signature? : String,
) -> MessageOriginChat {
  { date, sender_chat, author_signature }
}

///|
pub struct MessageOriginChannel {
  date : Int
  chat : Chat
  message_id : Int
  author_signature : String?
} derive(Show, Eq)

///|
pub fn MessageOriginChannel::new(
  date~ : Int,
  chat~ : Chat,
  message_id~ : Int,
  author_signature? : String,
) -> MessageOriginChannel {
  { date, chat, message_id, author_signature }
}

///|
pub(all) enum MessageOrigin {
  User(MessageOriginUser)
  HiddenUser(MessageOriginHiddenUser)
  Chat(MessageOriginChat)
  Channel(MessageOriginChannel)
} derive(Show, Eq)

///|
pub impl @json.ToJson for MessageOrigin with to_json(self) {
  match self {
    User(v) => {
      let obj : Map[String, Json] = {
        "type": "user",
        "date": @json.to_json(v.date),
        "sender_user": @json.to_json(v.sender_user),
      }
      @json.to_json(obj)
    }
    HiddenUser(v) => {
      let obj : Map[String, Json] = {
        "type": "hidden_user",
        "date": @json.to_json(v.date),
        "sender_user_name": @json.to_json(v.sender_user_name),
      }
      @json.to_json(obj)
    }
    Chat(v) => {
      let obj : Map[String, Json] = {
        "type": "chat",
        "date": @json.to_json(v.date),
        "sender_chat": @json.to_json(v.sender_chat),
      }
      if v.author_signature is Some(sig) {
        obj["author_signature"] = @json.to_json(sig)
      }
      @json.to_json(obj)
    }
    Channel(v) => {
      let obj : Map[String, Json] = {
        "type": "channel",
        "date": @json.to_json(v.date),
        "chat": @json.to_json(v.chat),
        "message_id": @json.to_json(v.message_id),
      }
      if v.author_signature is Some(sig) {
        obj["author_signature"] = @json.to_json(sig)
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for MessageOrigin with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for MessageOrigin")
  }
  guard obj["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field for MessageOrigin")
  }
  match type_ {
    "user" => {
      let date : Int = @json.from_json(obj["date"], path~)
      let sender_user : User = @json.from_json(obj["sender_user"], path~)
      User({ date, sender_user })
    }
    "hidden_user" => {
      let date : Int = @json.from_json(obj["date"], path~)
      let sender_user_name : String = @json.from_json(
        obj["sender_user_name"],
        path~,
      )
      HiddenUser({ date, sender_user_name })
    }
    "chat" => {
      let date : Int = @json.from_json(obj["date"], path~)
      let sender_chat : Chat = @json.from_json(obj["sender_chat"], path~)
      let author_signature : String? = if obj.get("author_signature") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Chat({ date, sender_chat, author_signature })
    }
    "channel" => {
      let date : Int = @json.from_json(obj["date"], path~)
      let chat : Chat = @json.from_json(obj["chat"], path~)
      let message_id : Int = @json.from_json(obj["message_id"], path~)
      let author_signature : String? = if obj.get("author_signature") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Channel({ date, chat, message_id, author_signature })
    }
    _ =>
      raise @json.JsonDecodeError(path~, "Unknown MessageOrigin type: \{type_}")
  }
}
