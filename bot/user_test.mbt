///|
test "User JSON round-trip" {
  let user : User = {
    id: 123L,
    is_bot: true,
    first_name: "TestBot",
    last_name: None,
    username: Some("test_bot"),
    language_code: None,
  }
  let json = user.to_json()
  let parsed : User = @json.from_json(json)
  inspect(parsed.id, content="123")
  inspect(parsed.is_bot, content="true")
  inspect(parsed.first_name, content="TestBot")
  inspect(parsed.username, content="Some(\"test_bot\")")
}
