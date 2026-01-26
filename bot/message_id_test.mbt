///|
test "MessageId JSON round-trip" {
  let msg_id = MessageId::new(message_id=12345)
  let json = @json.to_json(msg_id)
  let parsed : MessageId = @json.from_json(json)
  inspect(parsed.message_id, content="12345")
}
