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
  let json = update.to_json()
  let parsed : Update = @json.from_json(json)
  inspect(parsed.update_id, content="100")
  inspect(parsed.message is None, content="false")
}
