///|
test "LoginUrl JSON round-trip" {
  let login = LoginUrl::new(
    url="https://example.com/login",
    forward_text="Login to Example",
    bot_username="example_bot",
    request_write_access=true,
  )
  let json = @json.to_json(login)
  let parsed : LoginUrl = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/login")
  inspect(parsed.forward_text, content="Some(\"Login to Example\")")
  inspect(parsed.bot_username, content="Some(\"example_bot\")")
  inspect(parsed.request_write_access, content="Some(true)")
}

///|
test "LoginUrl JSON round-trip minimal" {
  let login = LoginUrl::new(url="https://example.com/login")
  let json = @json.to_json(login)
  let parsed : LoginUrl = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/login")
  inspect(parsed.forward_text, content="None")
  inspect(parsed.bot_username, content="None")
  inspect(parsed.request_write_access, content="None")
}

///|
test "SwitchInlineQueryChosenChat JSON round-trip" {
  let switch_chat = SwitchInlineQueryChosenChat::new(
    query="search query",
    allow_user_chats=true,
    allow_bot_chats=false,
    allow_group_chats=true,
    allow_channel_chats=false,
  )
  let json = @json.to_json(switch_chat)
  let parsed : SwitchInlineQueryChosenChat = @json.from_json(json)
  inspect(parsed.query, content="Some(\"search query\")")
  inspect(parsed.allow_user_chats, content="Some(true)")
  inspect(parsed.allow_bot_chats, content="Some(false)")
  inspect(parsed.allow_group_chats, content="Some(true)")
  inspect(parsed.allow_channel_chats, content="Some(false)")
}

///|
test "SwitchInlineQueryChosenChat JSON round-trip empty" {
  let switch_chat = SwitchInlineQueryChosenChat::new()
  let json = @json.to_json(switch_chat)
  let parsed : SwitchInlineQueryChosenChat = @json.from_json(json)
  inspect(parsed.query, content="None")
  inspect(parsed.allow_user_chats, content="None")
  inspect(parsed.allow_bot_chats, content="None")
  inspect(parsed.allow_group_chats, content="None")
  inspect(parsed.allow_channel_chats, content="None")
}

///|
test "CallbackGame JSON round-trip" {
  let game = CallbackGame::new()
  let json = @json.to_json(game)
  let parsed : CallbackGame = @json.from_json(json)
  inspect(parsed, content="{}")
}
