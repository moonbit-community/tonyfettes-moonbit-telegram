///|
test "Update JSON round-trip" {
  let update : Update = Update::new(
    update_id=100,
    message=Message::new(
      message_id=789,
      date=1640000000,
      chat=@bot.Chat::new(id=456L, type_=Group, title="Test Group"),
      text="Test message",
    ),
  )
  let json = @json.to_json(update)
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="100")
  inspect(parsed.message is None, content="false")
}

///|
test "Update with callback_query JSON round-trip" {
  let update : Update = Update::new(
    update_id=101,
    callback_query=CallbackQuery::new(
      id="callback_123",
      from=User::new(id=123L, is_bot=false, first_name="Alice"),
      chat_instance="instance_456",
      data="button_action",
    ),
  )
  let json = @json.to_json(update)
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="101")
  inspect(parsed.message, content="None")
  inspect(parsed.callback_query is None, content="false")
  inspect(
    parsed.callback_query.unwrap().data,
    content="Some(\"button_action\")",
  )
}
