///|
test "Message JSON round-trip" {
  let message : Message = Message::new(
    message_id=789,
    from=@bot.User::new(
      id=123L,
      is_bot=false,
      first_name="John",
      last_name="Doe",
      username="johndoe",
      language_code="en",
    ),
    date=1640000000,
    chat=Chat::new(
      id=456L,
      type_=Private,
      username="johndoe",
      first_name="John",
      last_name="Doe",
    ),
    text="Hello, world!",
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="789")
  inspect(parsed.text, content="Some(\"Hello, world!\")")
}

///|
test "Message with new fields JSON round-trip" {
  let direct_messages_topic = DirectMessagesTopic::new(
    id=1,
    name="Support",
    icon_color=16711680,
  )
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique123",
    width=512,
    height=512,
  )
  let gift = Gift::new(id="gift_id_123", sticker~, star_count=100)
  let gift_info = GiftInfo::new(gift~)
  let message : Message = Message::new(
    message_id=790,
    date=1640000001,
    chat=Chat::new(
      id=457L,
      type_=Private,
      username="janedoe",
      first_name="Jane",
      last_name="Doe",
    ),
    text="Test message with new fields",
    message_thread_id=5,
    is_topic_message=true,
    direct_messages_topic~,
    gift_upgrade_sent=gift_info,
    gift_id="gift_123",
    is_from_blockchain=true,
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="790")
  inspect(parsed.message_thread_id, content="Some(5)")
  inspect(parsed.is_topic_message, content="Some(true)")
  inspect(parsed.gift_id, content="Some(\"gift_123\")")
  inspect(parsed.is_from_blockchain, content="Some(true)")
}

///|
test "Message with direct_messages_topic field" {
  let direct_messages_topic = DirectMessagesTopic::new(
    id=2,
    name="General",
    icon_color=65280,
  )
  let message : Message = Message::new(
    message_id=791,
    date=1640000002,
    chat=Chat::new(id=458L, type_=Private, username="bob", first_name="Bob"),
    text="Message with topic",
    direct_messages_topic~,
  )
  let json = @json.to_json(message)
  let reconstructed : Message = @json.from_json(json)
  inspect(reconstructed.direct_messages_topic is Some(_), content="true")
  guard reconstructed.direct_messages_topic is Some(topic) else { return }
  inspect(topic.id, content="2")
  inspect(topic.name, content="General")
  inspect(topic.icon_color, content="65280")
}
