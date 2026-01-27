///|
test "ChatId JSON round-trip with integer ID" {
  let chat_id : ChatId = ChatId::Id(123456789L)
  let json = @json.to_json(chat_id)
  let parsed : ChatId = @json.from_json(json)
  inspect(parsed, content="Id(123456789)")
}

///|
test "ChatId JSON round-trip with username" {
  let chat_id : ChatId = ChatId::Username("@testchannel")
  let json = @json.to_json(chat_id)
  let parsed : ChatId = @json.from_json(json)
  inspect(parsed, content="Username(\"@testchannel\")")
}

///|
test "ReplyParameters JSON round-trip minimal" {
  let params = ReplyParameters::new(message_id=123)
  let json = @json.to_json(params)
  let parsed : ReplyParameters = @json.from_json(json)
  inspect(parsed.message_id, content="123")
  inspect(parsed.chat_id, content="None")
  inspect(parsed.allow_sending_without_reply, content="None")
  inspect(parsed.quote, content="None")
}

///|
test "ReplyParameters JSON round-trip with chat_id integer" {
  let params = ReplyParameters::new(
    message_id=456,
    chat_id=ChatId::Id(789L),
    allow_sending_without_reply=true,
  )
  let json = @json.to_json(params)
  let parsed : ReplyParameters = @json.from_json(json)
  inspect(parsed.message_id, content="456")
  inspect(parsed.chat_id, content="Some(Id(789))")
  inspect(parsed.allow_sending_without_reply, content="Some(true)")
}

///|
test "ReplyParameters JSON round-trip with chat_id username" {
  let params = ReplyParameters::new(
    message_id=100,
    chat_id=ChatId::Username("@mychannel"),
  )
  let json = @json.to_json(params)
  let parsed : ReplyParameters = @json.from_json(json)
  inspect(parsed.message_id, content="100")
  inspect(parsed.chat_id, content="Some(Username(\"@mychannel\"))")
}

///|
test "ReplyParameters JSON round-trip with quote" {
  let entity = MessageEntity::new(type_="bold", offset=0, length=5)
  let params = ReplyParameters::new(
    message_id=200,
    quote="Hello",
    quote_parse_mode="HTML",
    quote_entities=[entity],
    quote_position=10,
  )
  let json = @json.to_json(params)
  let parsed : ReplyParameters = @json.from_json(json)
  inspect(parsed.message_id, content="200")
  inspect(parsed.quote, content="Some(\"Hello\")")
  inspect(parsed.quote_parse_mode, content="Some(\"HTML\")")
  inspect(parsed.quote_position, content="Some(10)")
  guard parsed.quote_entities is Some(entities) else {
    fail("Expected quote_entities")
  }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="bold")
}

///|
test "MessageOriginPlaceholder JSON round-trip" {
  let origin = MessageOriginPlaceholder::new(type_="user", date=1700000000)
  let json = @json.to_json(origin)
  let parsed : MessageOriginPlaceholder = @json.from_json(json)
  inspect(parsed.type_, content="user")
  inspect(parsed.date, content="1700000000")
}

///|
test "LinkPreviewPlaceholder JSON round-trip" {
  let preview = LinkPreviewPlaceholder::new(is_disabled=true)
  let json = @json.to_json(preview)
  let parsed : LinkPreviewPlaceholder = @json.from_json(json)
  inspect(parsed.is_disabled, content="Some(true)")
}

///|
test "LinkPreviewPlaceholder JSON round-trip empty" {
  let preview = LinkPreviewPlaceholder::new()
  let json = @json.to_json(preview)
  let parsed : LinkPreviewPlaceholder = @json.from_json(json)
  inspect(parsed.is_disabled, content="None")
}

///|
test "GamePlaceholder JSON round-trip" {
  let game = GamePlaceholder::new(title="Test Game", description="A fun game")
  let json = @json.to_json(game)
  let parsed : GamePlaceholder = @json.from_json(json)
  inspect(parsed.title, content="Test Game")
  inspect(parsed.description, content="A fun game")
}

///|
test "ExternalReplyInfo JSON round-trip minimal" {
  let origin = MessageOriginPlaceholder::new(type_="user", date=1700000000)
  let reply_info = ExternalReplyInfo::new(origin~)
  let json = @json.to_json(reply_info)
  let parsed : ExternalReplyInfo = @json.from_json(json)
  inspect(parsed.origin.type_, content="user")
  inspect(parsed.origin.date, content="1700000000")
  inspect(parsed.chat, content="None")
  inspect(parsed.message_id, content="None")
}

///|
test "ExternalReplyInfo JSON round-trip with chat" {
  let origin = MessageOriginPlaceholder::new(type_="channel", date=1700000000)
  let chat = Chat::new(id=123L, type_=ChatType::Channel, title="Test Channel")
  let reply_info = ExternalReplyInfo::new(
    origin~,
    chat~,
    message_id=456,
    has_media_spoiler=true,
  )
  let json = @json.to_json(reply_info)
  let parsed : ExternalReplyInfo = @json.from_json(json)
  inspect(parsed.origin.type_, content="channel")
  inspect(parsed.message_id, content="Some(456)")
  inspect(parsed.has_media_spoiler, content="Some(true)")
  guard parsed.chat is Some(c) else { fail("Expected chat") }
  inspect(c.id, content="123")
}

///|
test "ExternalReplyInfo JSON round-trip with location" {
  let origin = MessageOriginPlaceholder::new(type_="user", date=1700000000)
  let loc = Location::new(latitude=37.7749, longitude=-122.4194)
  let reply_info = ExternalReplyInfo::new(origin~, location=loc)
  let json = @json.to_json(reply_info)
  let parsed : ExternalReplyInfo = @json.from_json(json)
  guard parsed.location is Some(l) else { fail("Expected location") }
  inspect(l.latitude, content="37.7749")
  inspect(l.longitude, content="-122.4194")
}

///|
test "ExternalReplyInfo JSON round-trip with game" {
  let origin = MessageOriginPlaceholder::new(type_="user", date=1700000000)
  let game = GamePlaceholder::new(title="Puzzle", description="Fun puzzle game")
  let reply_info = ExternalReplyInfo::new(origin~, game~)
  let json = @json.to_json(reply_info)
  let parsed : ExternalReplyInfo = @json.from_json(json)
  guard parsed.game is Some(g) else { fail("Expected game") }
  inspect(g.title, content="Puzzle")
  inspect(g.description, content="Fun puzzle game")
}

///|
test "ExternalReplyInfo JSON round-trip with link_preview_options" {
  let origin = MessageOriginPlaceholder::new(type_="user", date=1700000000)
  let preview = LinkPreviewPlaceholder::new(is_disabled=false)
  let reply_info = ExternalReplyInfo::new(origin~, link_preview_options=preview)
  let json = @json.to_json(reply_info)
  let parsed : ExternalReplyInfo = @json.from_json(json)
  guard parsed.link_preview_options is Some(lp) else {
    fail("Expected link_preview_options")
  }
  inspect(lp.is_disabled, content="Some(false)")
}
