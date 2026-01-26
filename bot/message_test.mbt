///|
test "Message JSON round-trip" {
  let message : Message = Message::new(
    message_id=789,
    from=@bot.User::new(
      id=123L,
      is_bot=false,
      first_name="John",
      last_name="Doe",
      username="johndoe",
      language_code="en",
    ),
    date=1640000000,
    chat=Chat::new(
      id=456L,
      type_=Private,
      username="johndoe",
      first_name="John",
      last_name="Doe",
    ),
    text="Hello, world!",
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="789")
  inspect(parsed.text, content="Some(\"Hello, world!\")")
}
