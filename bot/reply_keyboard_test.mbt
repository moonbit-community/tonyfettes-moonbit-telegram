///|
test "ReplyKeyboardMarkup simple JSON round-trip" {
  let keyboard = ReplyKeyboardMarkup::new(keyboard=[
    [KeyboardButton::new(text="Button 1"), KeyboardButton::new(text="Button 2")],
    [KeyboardButton::new(text="Button 3")],
  ])
  let json = @json.to_json(keyboard)
  let parsed : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(parsed.keyboard.length(), content="2")
  inspect(parsed.keyboard[0].length(), content="2")
  inspect(parsed.keyboard[0][0].text, content="Button 1")
  inspect(parsed.keyboard[1][0].text, content="Button 3")
  inspect(parsed.is_persistent, content="None")
  inspect(parsed.resize_keyboard, content="None")
}

///|
test "ReplyKeyboardMarkup with options JSON round-trip" {
  let keyboard = ReplyKeyboardMarkup::new(
    keyboard=[[KeyboardButton::new(text="OK")]],
    is_persistent=true,
    resize_keyboard=true,
    one_time_keyboard=true,
    input_field_placeholder="Enter text...",
    selective=false,
  )
  let json = @json.to_json(keyboard)
  let parsed : ReplyKeyboardMarkup = @json.from_json(json)
  inspect(parsed.keyboard.length(), content="1")
  inspect(parsed.is_persistent, content="Some(true)")
  inspect(parsed.resize_keyboard, content="Some(true)")
  inspect(parsed.one_time_keyboard, content="Some(true)")
  inspect(parsed.input_field_placeholder, content="Some(\"Enter text...\")")
  inspect(parsed.selective, content="Some(false)")
}

///|
test "ReplyKeyboardRemove JSON round-trip" {
  let remove = ReplyKeyboardRemove::new(remove_keyboard=true)
  let json = @json.to_json(remove)
  let parsed : ReplyKeyboardRemove = @json.from_json(json)
  inspect(parsed.remove_keyboard, content="true")
  inspect(parsed.selective, content="None")
}

///|
test "ReplyKeyboardRemove with selective JSON round-trip" {
  let remove = ReplyKeyboardRemove::new(remove_keyboard=true, selective=true)
  let json = @json.to_json(remove)
  let parsed : ReplyKeyboardRemove = @json.from_json(json)
  inspect(parsed.remove_keyboard, content="true")
  inspect(parsed.selective, content="Some(true)")
}

///|
test "ForceReply simple JSON round-trip" {
  let force = ForceReply::new(force_reply=true)
  let json = @json.to_json(force)
  let parsed : ForceReply = @json.from_json(json)
  inspect(parsed.force_reply, content="true")
  inspect(parsed.input_field_placeholder, content="None")
  inspect(parsed.selective, content="None")
}

///|
test "ForceReply with options JSON round-trip" {
  let force = ForceReply::new(
    force_reply=true,
    input_field_placeholder="Reply here...",
    selective=true,
  )
  let json = @json.to_json(force)
  let parsed : ForceReply = @json.from_json(json)
  inspect(parsed.force_reply, content="true")
  inspect(parsed.input_field_placeholder, content="Some(\"Reply here...\")")
  inspect(parsed.selective, content="Some(true)")
}
