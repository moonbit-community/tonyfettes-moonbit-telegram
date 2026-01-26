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
