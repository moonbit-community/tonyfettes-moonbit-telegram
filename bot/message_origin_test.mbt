///|
test "MessageOriginUser JSON round-trip" {
  let user = User::new(id=123L, is_bot=false, first_name="John")
  let origin : MessageOrigin = User(
    MessageOriginUser::new(date=1609459200, sender_user=user),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is User(v) else { fail("Expected MessageOrigin::User") }
  inspect(v.date, content="1609459200")
  inspect(v.sender_user.first_name, content="John")
}

///|
test "MessageOriginHiddenUser JSON round-trip" {
  let origin : MessageOrigin = HiddenUser(
    MessageOriginHiddenUser::new(date=1609459200, sender_user_name="Anonymous"),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is HiddenUser(v) else {
    fail("Expected MessageOrigin::HiddenUser")
  }
  inspect(v.date, content="1609459200")
  inspect(v.sender_user_name, content="Anonymous")
}

///|
test "MessageOriginChat JSON round-trip" {
  let chat = Chat::new(id=456L, type_=Group, title="Test Group")
  let origin : MessageOrigin = Chat(
    MessageOriginChat::new(
      date=1609459200,
      sender_chat=chat,
      author_signature="Admin",
    ),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.date, content="1609459200")
  inspect(v.sender_chat.id, content="456")
  inspect(v.author_signature, content="Some(\"Admin\")")
}

///|
test "MessageOriginChat without author_signature" {
  let chat = Chat::new(id=789L, type_=Supergroup, title="Super Group")
  let origin : MessageOrigin = Chat(
    MessageOriginChat::new(date=1609459200, sender_chat=chat),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected MessageOrigin::Chat") }
  inspect(v.author_signature, content="None")
}

///|
test "MessageOriginChannel JSON round-trip" {
  let chat = Chat::new(id=100L, type_=Channel, title="News Channel")
  let origin : MessageOrigin = Channel(
    MessageOriginChannel::new(
      date=1609459200,
      chat~,
      message_id=42,
      author_signature="Editor",
    ),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.date, content="1609459200")
  inspect(v.chat.id, content="100")
  inspect(v.message_id, content="42")
  inspect(v.author_signature, content="Some(\"Editor\")")
}

///|
test "MessageOriginChannel without author_signature" {
  let chat = Chat::new(id=200L, type_=Channel, title="Tech News")
  let origin : MessageOrigin = Channel(
    MessageOriginChannel::new(date=1609459200, chat~, message_id=99),
  )
  let json = @json.to_json(origin)
  let parsed : MessageOrigin = @json.from_json(json)
  guard parsed is Channel(v) else { fail("Expected MessageOrigin::Channel") }
  inspect(v.author_signature, content="None")
}
