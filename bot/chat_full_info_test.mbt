///|
test "Birthdate JSON round-trip" {
  let birthdate = Birthdate::new(day=15, month=6, year=1990)
  let json = @json.to_json(birthdate)
  let parsed : Birthdate = @json.from_json(json)
  inspect(parsed.day, content="15")
  inspect(parsed.month, content="6")
  inspect(parsed.year, content="Some(1990)")
}

///|
test "Birthdate JSON round-trip without year" {
  let birthdate = Birthdate::new(day=25, month=12)
  let json = @json.to_json(birthdate)
  let parsed : Birthdate = @json.from_json(json)
  inspect(parsed.day, content="25")
  inspect(parsed.month, content="12")
  inspect(parsed.year, content="None")
}

///|
test "ChatLocation JSON round-trip" {
  let location = Location::new(latitude=40.7128, longitude=-74.006)
  let chat_location = ChatLocation::new(
    location~,
    address="123 Main St, New York, NY",
  )
  let json = @json.to_json(chat_location)
  let parsed : ChatLocation = @json.from_json(json)
  inspect(parsed.address, content="123 Main St, New York, NY")
  inspect(parsed.location.latitude, content="40.7128")
}

///|
test "BusinessIntro JSON round-trip" {
  let intro = BusinessIntro::new(
    title="Welcome",
    message="Hello, how can I help you?",
  )
  let json = @json.to_json(intro)
  let parsed : BusinessIntro = @json.from_json(json)
  inspect(parsed.title, content="Some(\"Welcome\")")
  inspect(parsed.message, content="Some(\"Hello, how can I help you?\")")
}

///|
test "BusinessLocation JSON round-trip" {
  let location = Location::new(latitude=51.5074, longitude=-0.1278)
  let bus_location = BusinessLocation::new(
    address="10 Downing Street, London",
    location~,
  )
  let json = @json.to_json(bus_location)
  let parsed : BusinessLocation = @json.from_json(json)
  inspect(parsed.address, content="10 Downing Street, London")
  inspect(parsed.location is Some(_), content="true")
}

///|
test "BusinessOpeningHoursInterval JSON round-trip" {
  let interval = BusinessOpeningHoursInterval::new(
    opening_minute=540,
    closing_minute=1080,
  )
  let json = @json.to_json(interval)
  let parsed : BusinessOpeningHoursInterval = @json.from_json(json)
  inspect(parsed.opening_minute, content="540")
  inspect(parsed.closing_minute, content="1080")
}

///|
test "BusinessOpeningHours JSON round-trip" {
  let hours = BusinessOpeningHours::new(time_zone_name="America/New_York", opening_hours=[
    BusinessOpeningHoursInterval::new(opening_minute=540, closing_minute=1080),
    BusinessOpeningHoursInterval::new(opening_minute=1980, closing_minute=2520),
  ])
  let json = @json.to_json(hours)
  let parsed : BusinessOpeningHours = @json.from_json(json)
  inspect(parsed.time_zone_name, content="America/New_York")
  inspect(parsed.opening_hours.length(), content="2")
}

///|
test "ReactionTypeEmoji JSON round-trip" {
  let reaction = ReactionTypeEmoji::new(emoji="thumbs_up")
  let json = @json.to_json(reaction)
  let parsed : ReactionTypeEmoji = @json.from_json(json)
  inspect(parsed.emoji, content="thumbs_up")
}

///|
test "ReactionTypeCustomEmoji JSON round-trip" {
  let reaction = ReactionTypeCustomEmoji::new(custom_emoji_id="12345")
  let json = @json.to_json(reaction)
  let parsed : ReactionTypeCustomEmoji = @json.from_json(json)
  inspect(parsed.custom_emoji_id, content="12345")
}

///|
test "ReactionType Emoji JSON round-trip" {
  let reaction : ReactionType = Emoji(ReactionTypeEmoji::new(emoji="heart"))
  let json = @json.to_json(reaction)
  let parsed : ReactionType = @json.from_json(json)
  guard parsed is Emoji(e) else { fail("Expected Emoji variant") }
  inspect(e.emoji, content="heart")
}

///|
test "ReactionType CustomEmoji JSON round-trip" {
  let reaction : ReactionType = CustomEmoji(
    ReactionTypeCustomEmoji::new(custom_emoji_id="abc123"),
  )
  let json = @json.to_json(reaction)
  let parsed : ReactionType = @json.from_json(json)
  guard parsed is CustomEmoji(ce) else { fail("Expected CustomEmoji variant") }
  inspect(ce.custom_emoji_id, content="abc123")
}

///|
test "ChatFullInfo minimal JSON round-trip" {
  let info = ChatFullInfo::new(
    id=123456789L,
    type_="private",
    accent_color_id=1,
    max_reaction_count=11,
  )
  let json = @json.to_json(info)
  let parsed : ChatFullInfo = @json.from_json(json)
  inspect(parsed.id, content="123456789")
  inspect(parsed.type_, content="private")
  inspect(parsed.accent_color_id, content="1")
  inspect(parsed.max_reaction_count, content="11")
}

///|
test "ChatFullInfo with optional fields JSON round-trip" {
  let info = ChatFullInfo::new(
    id=987654321L,
    type_="supergroup",
    accent_color_id=5,
    max_reaction_count=20,
    title="Test Group",
    username="testgroup",
    is_forum=true,
    bio="This is a test group",
    description="A group for testing",
    invite_link="https://t.me/joinchat/abc123",
    slow_mode_delay=30,
    has_protected_content=true,
    has_visible_history=true,
  )
  let json = @json.to_json(info)
  let parsed : ChatFullInfo = @json.from_json(json)
  inspect(parsed.id, content="987654321")
  inspect(parsed.type_, content="supergroup")
  inspect(parsed.title, content="Some(\"Test Group\")")
  inspect(parsed.username, content="Some(\"testgroup\")")
  inspect(parsed.is_forum, content="Some(true)")
  inspect(parsed.bio, content="Some(\"This is a test group\")")
  inspect(parsed.slow_mode_delay, content="Some(30)")
  inspect(parsed.has_protected_content, content="Some(true)")
}

///|
test "ChatFullInfo with birthdate JSON round-trip" {
  let birthdate = Birthdate::new(day=1, month=1, year=2000)
  let info = ChatFullInfo::new(
    id=111L,
    type_="private",
    accent_color_id=0,
    max_reaction_count=5,
    first_name="John",
    last_name="Doe",
    birthdate~,
  )
  let json = @json.to_json(info)
  let parsed : ChatFullInfo = @json.from_json(json)
  inspect(parsed.first_name, content="Some(\"John\")")
  inspect(parsed.last_name, content="Some(\"Doe\")")
  guard parsed.birthdate is Some(bd) else { fail("Expected birthdate") }
  inspect(bd.day, content="1")
  inspect(bd.month, content="1")
  inspect(bd.year, content="Some(2000)")
}

///|
test "ChatFullInfo with location JSON round-trip" {
  let location = Location::new(latitude=48.8566, longitude=2.3522)
  let chat_location = ChatLocation::new(location~, address="Paris, France")
  let info = ChatFullInfo::new(
    id=222L,
    type_="supergroup",
    accent_color_id=2,
    max_reaction_count=10,
    title="Paris Group",
    location=chat_location,
  )
  let json = @json.to_json(info)
  let parsed : ChatFullInfo = @json.from_json(json)
  guard parsed.location is Some(loc) else { fail("Expected location") }
  inspect(loc.address, content="Paris, France")
  inspect(loc.location.latitude, content="48.8566")
}

///|
test "ChatFullInfo with available_reactions JSON round-trip" {
  let reactions : Array[ReactionType] = [
    Emoji(ReactionTypeEmoji::new(emoji="thumbs_up")),
    CustomEmoji(ReactionTypeCustomEmoji::new(custom_emoji_id="custom1")),
  ]
  let info = ChatFullInfo::new(
    id=333L,
    type_="supergroup",
    accent_color_id=3,
    max_reaction_count=15,
    available_reactions=reactions,
  )
  let json = @json.to_json(info)
  let parsed : ChatFullInfo = @json.from_json(json)
  guard parsed.available_reactions is Some(r) else {
    fail("Expected available_reactions")
  }
  inspect(r.length(), content="2")
}
