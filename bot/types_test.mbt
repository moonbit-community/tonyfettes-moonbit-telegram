///|
test "User JSON round-trip" {
  let user : User = {
    id: 123L,
    is_bot: true,
    first_name: "TestBot",
    last_name: None,
    username: Some("test_bot"),
    language_code: None,
  }
  let json = user.to_json()
  let parsed : User = @json.from_json(json)
  inspect(parsed.id, content="123")
  inspect(parsed.is_bot, content="true")
  inspect(parsed.first_name, content="TestBot")
  inspect(parsed.username, content="Some(\"test_bot\")")
}

///|
test "ChatType JSON round-trip" {
  let types : Array[ChatType] = [Private, Group, Supergroup, Channel]
  for ct in types {
    let json = ct.to_json()
    let parsed : ChatType = @json.from_json(json)
    inspect(ct == parsed, content="true")
  }
}

///|
test "Chat JSON round-trip" {
  let chat : Chat = {
    id: 456L,
    type_: Private,
    title: None,
    username: Some("testuser"),
    first_name: Some("Test"),
    last_name: Some("User"),
  }
  let json = chat.to_json()
  let parsed : Chat = @json.from_json(json)
  inspect(parsed.id, content="456")
  inspect(parsed.type_, content="Private")
  inspect(parsed.username, content="Some(\"testuser\")")
}

///|
test "Message JSON round-trip" {
  let message : Message = {
    message_id: 789,
    from: Some({
      id: 123L,
      is_bot: false,
      first_name: "John",
      last_name: Some("Doe"),
      username: Some("johndoe"),
      language_code: Some("en"),
    }),
    date: 1640000000,
    chat: {
      id: 456L,
      type_: Private,
      title: None,
      username: Some("johndoe"),
      first_name: Some("John"),
      last_name: Some("Doe"),
    },
    text: Some("Hello, world!"),
    entities: None,
    reply_to_message: None,
  }
  let json = message.to_json()
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="789")
  inspect(parsed.text, content="Some(\"Hello, world!\")")
}

///|
test "Update JSON round-trip" {
  let update : Update = {
    update_id: 100,
    message: Some({
      message_id: 789,
      from: None,
      date: 1640000000,
      chat: {
        id: 456L,
        type_: Group,
        title: Some("Test Group"),
        username: None,
        first_name: None,
        last_name: None,
      },
      text: Some("Test message"),
      entities: None,
      reply_to_message: None,
    }),
    edited_message: None,
  }
  let json = update.to_json()
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="100")
  inspect(parsed.message is None, content="false")
}
