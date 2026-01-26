///|
test "WebAppInfo JSON round-trip" {
  let info = WebAppInfo::new(url="https://example.com/webapp")
  let json = @json.to_json(info)
  let parsed : WebAppInfo = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/webapp")
}

///|
test "SentWebAppMessage JSON round-trip with inline_message_id" {
  let msg = SentWebAppMessage::new(inline_message_id="abc123")
  let json = @json.to_json(msg)
  let parsed : SentWebAppMessage = @json.from_json(json)
  inspect(parsed.inline_message_id, content="Some(\"abc123\")")
}

///|
test "SentWebAppMessage JSON round-trip without inline_message_id" {
  let msg = SentWebAppMessage::new()
  let json = @json.to_json(msg)
  let parsed : SentWebAppMessage = @json.from_json(json)
  inspect(parsed.inline_message_id, content="None")
}
