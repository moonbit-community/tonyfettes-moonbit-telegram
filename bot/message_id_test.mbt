///|
test "MessageId JSON round-trip" {
  let msg_id = MessageId::new(message_id=12345)
  let json = msg_id.to_json()
  let parsed : MessageId = @json.from_json(json)
  inspect(parsed.message_id, content="12345")
}
