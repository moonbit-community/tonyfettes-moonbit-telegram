///|
test "DirectMessagesTopic JSON round-trip" {
  let original = DirectMessagesTopic::new(
    id=123,
    name="Support",
    icon_color=16711680,
  )
  let json = @json.to_json(original)
  let decoded : DirectMessagesTopic = @json.from_json(json)
  inspect(decoded.id, content="123")
  inspect(decoded.name, content="Support")
  inspect(decoded.icon_color, content="16711680")
}

///|
test "DirectMessagesTopic ToJson and FromJson" {
  let topic = DirectMessagesTopic::new(id=456, name="General", icon_color=65280)
  let json = @json.to_json(topic)
  let reconstructed : DirectMessagesTopic = @json.from_json(json)
  inspect(reconstructed.id, content="456")
  inspect(reconstructed.name, content="General")
  inspect(reconstructed.icon_color, content="65280")
}
