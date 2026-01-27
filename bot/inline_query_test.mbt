///|
test "InlineQuery JSON round-trip" {
  let user = User::new(id=123L, is_bot=false, first_name="TestUser")
  let location = Location::new(latitude=40.7128, longitude=-74.006)
  let inline_query = InlineQuery::new(
    id="query123",
    from=user,
    query="search term",
    offset="0",
    chat_type="private",
    location~,
  )
  let json = @json.to_json(inline_query)
  let parsed : InlineQuery = @json.from_json(json)
  inspect(parsed.id, content="query123")
  inspect(parsed.from.id, content="123")
  inspect(parsed.query, content="search term")
  inspect(parsed.offset, content="0")
  inspect(parsed.chat_type, content="Some(\"private\")")
  inspect(parsed.location.map(fn(l) { l.latitude }), content="Some(40.7128)")
}

///|
test "InlineQuery JSON round-trip minimal" {
  let user = User::new(id=456L, is_bot=true, first_name="Bot")
  let inline_query = InlineQuery::new(
    id="query456",
    from=user,
    query="",
    offset="10",
  )
  let json = @json.to_json(inline_query)
  let parsed : InlineQuery = @json.from_json(json)
  inspect(parsed.id, content="query456")
  inspect(parsed.chat_type, content="None")
  inspect(parsed.location, content="None")
}

///|
test "ChosenInlineResult JSON round-trip" {
  let user = User::new(id=789L, is_bot=false, first_name="Chooser")
  let location = Location::new(latitude=51.5074, longitude=-0.1278)
  let result = ChosenInlineResult::new(
    result_id="result123",
    from=user,
    query="chosen query",
    location~,
    inline_message_id="msg123",
  )
  let json = @json.to_json(result)
  let parsed : ChosenInlineResult = @json.from_json(json)
  inspect(parsed.result_id, content="result123")
  inspect(parsed.from.id, content="789")
  inspect(parsed.query, content="chosen query")
  inspect(parsed.inline_message_id, content="Some(\"msg123\")")
  inspect(parsed.location.map(fn(l) { l.latitude }), content="Some(51.5074)")
}

///|
test "ChosenInlineResult JSON round-trip minimal" {
  let user = User::new(id=101L, is_bot=false, first_name="Simple")
  let result = ChosenInlineResult::new(
    result_id="result456",
    from=user,
    query="simple query",
  )
  let json = @json.to_json(result)
  let parsed : ChosenInlineResult = @json.from_json(json)
  inspect(parsed.result_id, content="result456")
  inspect(parsed.location, content="None")
  inspect(parsed.inline_message_id, content="None")
}

///|
test "InlineQueryResultsButton JSON round-trip" {
  let web_app = WebAppInfo::new(url="https://example.com/app")
  let button = InlineQueryResultsButton::new(
    text="Open App",
    web_app~,
    start_parameter="start123",
  )
  let json = @json.to_json(button)
  let parsed : InlineQueryResultsButton = @json.from_json(json)
  inspect(parsed.text, content="Open App")
  inspect(
    parsed.web_app.map(fn(w) { w.url }),
    content="Some(\"https://example.com/app\")",
  )
  inspect(parsed.start_parameter, content="Some(\"start123\")")
}

///|
test "InlineQueryResultsButton JSON round-trip minimal" {
  let button = InlineQueryResultsButton::new(text="Click Me")
  let json = @json.to_json(button)
  let parsed : InlineQueryResultsButton = @json.from_json(json)
  inspect(parsed.text, content="Click Me")
  inspect(parsed.web_app, content="None")
  inspect(parsed.start_parameter, content="None")
}
