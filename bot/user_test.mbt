///|
test "User JSON round-trip" {
  let user : User = User::new(
    id=123L,
    is_bot=true,
    first_name="TestBot",
    username="test_bot",
  )
  let json = @json.to_json(user)
  let parsed : User = @json.from_json(json)
  inspect(parsed.id, content="123")
  inspect(parsed.is_bot, content="true")
  inspect(parsed.first_name, content="TestBot")
  inspect(parsed.username, content="Some(\"test_bot\")")
}
