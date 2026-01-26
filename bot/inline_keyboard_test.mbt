///|
test "InlineKeyboardButton with callback_data JSON round-trip" {
  let button = InlineKeyboardButton::new(text="Click me", callback_data="btn_1")
  let json = @json.to_json(button)
  let parsed : InlineKeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Click me")
  inspect(parsed.callback_data, content="Some(\"btn_1\")")
  inspect(parsed.url, content="None")
}

///|
test "InlineKeyboardButton with url JSON round-trip" {
  let button = InlineKeyboardButton::new(
    text="Visit site",
    url="https://example.com",
  )
  let json = @json.to_json(button)
  let parsed : InlineKeyboardButton = @json.from_json(json)
  inspect(parsed.text, content="Visit site")
  inspect(parsed.url, content="Some(\"https://example.com\")")
  inspect(parsed.callback_data, content="None")
}

///|
test "InlineKeyboardMarkup JSON round-trip" {
  let keyboard = InlineKeyboardMarkup::new(inline_keyboard=[
    [
      InlineKeyboardButton::new(text="Button 1", callback_data="1"),
      InlineKeyboardButton::new(text="Button 2", callback_data="2"),
    ],
    [InlineKeyboardButton::new(text="URL", url="https://example.com")],
  ])
  let json = @json.to_json(keyboard)
  let parsed : InlineKeyboardMarkup = @json.from_json(json)
  inspect(parsed.inline_keyboard.length(), content="2")
  inspect(parsed.inline_keyboard[0].length(), content="2")
  inspect(parsed.inline_keyboard[0][0].text, content="Button 1")
  inspect(
    parsed.inline_keyboard[1][0].url,
    content="Some(\"https://example.com\")",
  )
}
