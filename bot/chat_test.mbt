///|
test "ChatType JSON round-trip" {
  let types : Array[ChatType] = [Private, Group, Supergroup, Channel]
  for ct in types {
    let json = @json.to_json(ct)
    let parsed : ChatType = @json.from_json(json)
    inspect(ct == parsed, content="true")
  }
}

///|
test "Chat JSON round-trip" {
  let chat : Chat = Chat::new(
    id=456L,
    type_=Private,
    username=("testuser"),
    first_name=("Test"),
    last_name=("User"),
  )
  let json = @json.to_json(chat)
  let parsed : Chat = @json.from_json(json)
  inspect(parsed.id, content="456")
  inspect(parsed.type_, content="Private")
  inspect(parsed.username, content="Some(\"testuser\")")
}
