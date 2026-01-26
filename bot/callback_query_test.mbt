///|
test "CallbackQuery JSON round-trip" {
  let query = CallbackQuery::new(
    id="123456789",
    from=User::new(id=123L, is_bot=false, first_name="John"),
    message=Message::new(
      message_id=789,
      date=1640000000,
      chat=Chat::new(id=456L, type_=Private),
    ),
    chat_instance="987654321",
    data="button_clicked",
  )
  let json = query.to_json()
  let parsed : CallbackQuery = @json.from_json(json)
  inspect(parsed.id, content="123456789")
  inspect(parsed.from.first_name, content="John")
  inspect(parsed.chat_instance, content="987654321")
  inspect(parsed.data, content="Some(\"button_clicked\")")
  inspect(parsed.message is None, content="false")
}

///|
test "CallbackQuery without message JSON round-trip" {
  let query = CallbackQuery::new(
    id="123456789",
    from=User::new(id=123L, is_bot=false, first_name="Jane"),
    inline_message_id="inline_123",
    chat_instance="987654321",
    data="inline_button",
  )
  let json = query.to_json()
  let parsed : CallbackQuery = @json.from_json(json)
  inspect(parsed.id, content="123456789")
  inspect(parsed.message, content="None")
  inspect(parsed.inline_message_id, content="Some(\"inline_123\")")
}
