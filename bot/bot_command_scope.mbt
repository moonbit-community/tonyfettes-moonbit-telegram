///|
pub(all) struct BotCommandScopeChat {
  chat_id : Int64
} derive(Show, Eq)

///|
pub fn BotCommandScopeChat::new(chat_id~ : Int64) -> BotCommandScopeChat {
  { chat_id, }
}

///|
pub(all) struct BotCommandScopeChatAdministrators {
  chat_id : Int64
} derive(Show, Eq)

///|
pub fn BotCommandScopeChatAdministrators::new(
  chat_id~ : Int64,
) -> BotCommandScopeChatAdministrators {
  { chat_id, }
}

///|
pub(all) struct BotCommandScopeChatMember {
  chat_id : Int64
  user_id : Int64
} derive(Show, Eq)

///|
pub fn BotCommandScopeChatMember::new(
  chat_id~ : Int64,
  user_id~ : Int64,
) -> BotCommandScopeChatMember {
  { chat_id, user_id }
}

///|
pub(all) enum BotCommandScope {
  Default
  AllPrivateChats
  AllGroupChats
  AllChatAdministrators
  Chat(BotCommandScopeChat)
  ChatAdministrators(BotCommandScopeChatAdministrators)
  ChatMember(BotCommandScopeChatMember)
} derive(Show, Eq)

///|
pub impl @json.ToJson for BotCommandScope with to_json(self) {
  match self {
    Default => {
      let object : Map[String, Json] = { "type": "default" }
      @json.to_json(object)
    }
    AllPrivateChats => {
      let object : Map[String, Json] = { "type": "all_private_chats" }
      @json.to_json(object)
    }
    AllGroupChats => {
      let object : Map[String, Json] = { "type": "all_group_chats" }
      @json.to_json(object)
    }
    AllChatAdministrators => {
      let object : Map[String, Json] = { "type": "all_chat_administrators" }
      @json.to_json(object)
    }
    Chat(v) => {
      let object : Map[String, Json] = {
        "type": "chat",
        "chat_id": @json.to_json(v.chat_id),
      }
      @json.to_json(object)
    }
    ChatAdministrators(v) => {
      let object : Map[String, Json] = {
        "type": "chat_administrators",
        "chat_id": @json.to_json(v.chat_id),
      }
      @json.to_json(object)
    }
    ChatMember(v) => {
      let object : Map[String, Json] = {
        "type": "chat_member",
        "chat_id": @json.to_json(v.chat_id),
        "user_id": @json.to_json(v.user_id),
      }
      @json.to_json(object)
    }
  }
}

///|
pub impl @json.FromJson for BotCommandScope with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for BotCommandScope")
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected type field for BotCommandScope",
    )
  }
  match type_ {
    "default" => Default
    "all_private_chats" => AllPrivateChats
    "all_group_chats" => AllGroupChats
    "all_chat_administrators" => AllChatAdministrators
    "chat" => {
      let chat_id : Int64 = @json.from_json(object["chat_id"], path~)
      Chat({ chat_id, })
    }
    "chat_administrators" => {
      let chat_id : Int64 = @json.from_json(object["chat_id"], path~)
      ChatAdministrators({ chat_id, })
    }
    "chat_member" => {
      let chat_id : Int64 = @json.from_json(object["chat_id"], path~)
      let user_id : Int64 = @json.from_json(object["user_id"], path~)
      ChatMember({ chat_id, user_id })
    }
    _ =>
      raise @json.JsonDecodeError(
        path~,
        "Unknown BotCommandScope type: \{type_}",
      )
  }
}
