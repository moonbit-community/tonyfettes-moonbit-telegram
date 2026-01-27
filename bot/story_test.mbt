///|
test "Story JSON round-trip" {
  let chat = Chat::new(id=123456L, type_=ChatType::Private, first_name="Alice")
  let story = Story::new(chat~, id=42)
  let json = @json.to_json(story)
  let parsed : Story = @json.from_json(json)
  inspect(parsed.id, content="42")
  inspect(parsed.chat.id, content="123456")
  inspect(parsed.chat.type_, content="Private")
  inspect(parsed.chat.first_name, content="Some(\"Alice\")")
}

///|
test "Story with group chat JSON round-trip" {
  let chat = Chat::new(id=789L, type_=ChatType::Group, title="Test Group")
  let story = Story::new(chat~, id=100)
  let json = @json.to_json(story)
  let parsed : Story = @json.from_json(json)
  inspect(parsed.id, content="100")
  inspect(parsed.chat.id, content="789")
  inspect(parsed.chat.type_, content="Group")
  inspect(parsed.chat.title, content="Some(\"Test Group\")")
}
