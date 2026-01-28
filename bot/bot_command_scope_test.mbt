///|
test "BotCommandScope Default JSON round-trip" {
  let object : BotCommandScope = Default
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="Default")
}

///|
test "BotCommandScope AllPrivateChats JSON round-trip" {
  let object : BotCommandScope = AllPrivateChats
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllPrivateChats")
}

///|
test "BotCommandScope AllGroupChats JSON round-trip" {
  let object : BotCommandScope = AllGroupChats
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllGroupChats")
}

///|
test "BotCommandScope AllChatAdministrators JSON round-trip" {
  let object : BotCommandScope = AllChatAdministrators
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllChatAdministrators")
}

///|
test "BotCommandScope Chat JSON round-trip" {
  let object : BotCommandScope = Chat({ chat_id: 123L })
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected Chat") }
  inspect(v.chat_id, content="123")
}

///|
test "BotCommandScope ChatAdministrators JSON round-trip" {
  let object : BotCommandScope = ChatAdministrators({ chat_id: 456L })
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatAdministrators(v) else {
    fail("Expected ChatAdministrators")
  }
  inspect(v.chat_id, content="456")
}

///|
test "BotCommandScope ChatMember JSON round-trip" {
  let object : BotCommandScope = ChatMember({ chat_id: 123L, user_id: 456L })
  let json = @json.to_json(object)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatMember(v) else { fail("Expected ChatMember") }
  inspect(v.chat_id, content="123")
  inspect(v.user_id, content="456")
}

///|
test "BotCommandScopeChat new constructor" {
  let object = BotCommandScopeChat::new(chat_id=789L)
  inspect(object.chat_id, content="789")
}

///|
test "BotCommandScopeChatAdministrators new constructor" {
  let object = BotCommandScopeChatAdministrators::new(chat_id=789L)
  inspect(object.chat_id, content="789")
}

///|
test "BotCommandScopeChatMember new constructor" {
  let object = BotCommandScopeChatMember::new(chat_id=123L, user_id=456L)
  inspect(object.chat_id, content="123")
  inspect(object.user_id, content="456")
}
