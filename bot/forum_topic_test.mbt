///|
test "ForumTopic JSON round-trip" {
  let topic = ForumTopic::new(
    message_thread_id=12345,
    name="General Discussion",
    icon_color=0x6FB9F0,
    icon_custom_emoji_id="5368324170671202286",
  )
  let json = @json.to_json(topic)
  let parsed : ForumTopic = @json.from_json(json)
  inspect(parsed.message_thread_id, content="12345")
  inspect(parsed.name, content="General Discussion")
  inspect(parsed.icon_color, content="7322096")
  inspect(parsed.icon_custom_emoji_id, content="Some(\"5368324170671202286\")")
}

///|
test "ForumTopic JSON round-trip without optional fields" {
  let topic = ForumTopic::new(
    message_thread_id=67890,
    name="Announcements",
    icon_color=0xFFD67E,
  )
  let json = @json.to_json(topic)
  let parsed : ForumTopic = @json.from_json(json)
  inspect(parsed.message_thread_id, content="67890")
  inspect(parsed.name, content="Announcements")
  inspect(parsed.icon_color, content="16766590")
  inspect(parsed.icon_custom_emoji_id, content="None")
}

///|
test "ForumTopicCreated JSON round-trip" {
  let created = ForumTopicCreated::new(
    name="New Topic",
    icon_color=0x6FB9F0,
    icon_custom_emoji_id="5368324170671202286",
  )
  let json = @json.to_json(created)
  let parsed : ForumTopicCreated = @json.from_json(json)
  inspect(parsed.name, content="New Topic")
  inspect(parsed.icon_color, content="7322096")
  inspect(parsed.icon_custom_emoji_id, content="Some(\"5368324170671202286\")")
}

///|
test "ForumTopicCreated JSON round-trip without optional fields" {
  let created = ForumTopicCreated::new(
    name="Another Topic",
    icon_color=0xFFD67E,
  )
  let json = @json.to_json(created)
  let parsed : ForumTopicCreated = @json.from_json(json)
  inspect(parsed.name, content="Another Topic")
  inspect(parsed.icon_color, content="16766590")
  inspect(parsed.icon_custom_emoji_id, content="None")
}

///|
test "ForumTopicEdited JSON round-trip with all fields" {
  let edited = ForumTopicEdited::new(
    name="Edited Topic Name",
    icon_custom_emoji_id="5368324170671202286",
  )
  let json = @json.to_json(edited)
  let parsed : ForumTopicEdited = @json.from_json(json)
  inspect(parsed.name, content="Some(\"Edited Topic Name\")")
  inspect(parsed.icon_custom_emoji_id, content="Some(\"5368324170671202286\")")
}

///|
test "ForumTopicEdited JSON round-trip with only name" {
  let edited = ForumTopicEdited::new(name="Just Name Changed")
  let json = @json.to_json(edited)
  let parsed : ForumTopicEdited = @json.from_json(json)
  inspect(parsed.name, content="Some(\"Just Name Changed\")")
  inspect(parsed.icon_custom_emoji_id, content="None")
}

///|
test "ForumTopicEdited JSON round-trip with only icon" {
  let edited = ForumTopicEdited::new(icon_custom_emoji_id="5368324170671202286")
  let json = @json.to_json(edited)
  let parsed : ForumTopicEdited = @json.from_json(json)
  inspect(parsed.name, content="None")
  inspect(parsed.icon_custom_emoji_id, content="Some(\"5368324170671202286\")")
}

///|
test "ForumTopicEdited JSON round-trip with no fields" {
  let edited = ForumTopicEdited::new()
  let json = @json.to_json(edited)
  let parsed : ForumTopicEdited = @json.from_json(json)
  inspect(parsed.name, content="None")
  inspect(parsed.icon_custom_emoji_id, content="None")
}
