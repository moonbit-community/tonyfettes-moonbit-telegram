///|
test "Voice JSON round-trip" {
  let voice = Voice::new(
    file_id="AwACAgIAAxkBAAI",
    file_unique_id="AQADAgATvoice",
    duration=15,
    mime_type="audio/ogg",
    file_size=25000L,
  )
  let json = @json.to_json(voice)
  let parsed : Voice = @json.from_json(json)
  inspect(parsed.file_id, content="AwACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATvoice")
  inspect(parsed.duration, content="15")
  inspect(parsed.mime_type, content="Some(\"audio/ogg\")")
  inspect(parsed.file_size, content="Some(25000)")
}

///|
test "Voice JSON round-trip without optionals" {
  let voice = Voice::new(
    file_id="AwACAgIAAxkBAAI",
    file_unique_id="AQADAgATvoice",
    duration=15,
  )
  let json = @json.to_json(voice)
  let parsed : Voice = @json.from_json(json)
  inspect(parsed.file_id, content="AwACAgIAAxkBAAI")
  inspect(parsed.mime_type, content="None")
  inspect(parsed.file_size, content="None")
}
