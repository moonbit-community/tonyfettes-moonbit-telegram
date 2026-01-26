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
