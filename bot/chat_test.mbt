///|
test "ChatType JSON round-trip" {
  let types : Array[ChatType] = [Private, Group, Supergroup, Channel]
  for ct in types {
    let json = ct.to_json()
    let parsed : ChatType = @json.from_json(json)
    inspect(ct == parsed, content="true")
  }
}

///|
test "Chat JSON round-trip" {
  let chat : Chat = {
    id: 456L,
    type_: Private,
    title: None,
    username: Some("testuser"),
    first_name: Some("Test"),
    last_name: Some("User"),
  }
  let json = chat.to_json()
  let parsed : Chat = @json.from_json(json)
  inspect(parsed.id, content="456")
  inspect(parsed.type_, content="Private")
  inspect(parsed.username, content="Some(\"testuser\")")
}
