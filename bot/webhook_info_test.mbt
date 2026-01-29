///|
test "WebhookInfo JSON round-trip" {
  let webhook_info : WebhookInfo = WebhookInfo::new(
    url="https://example.com/webhook",
    has_custom_certificate=true,
    pending_update_count=0,
    ip_address="1.2.3.4",
    max_connections=40,
    allowed_updates=["message", "callback_query"],
  )
  let json = @json.to_json(webhook_info)
  let parsed : WebhookInfo = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/webhook")
  inspect(parsed.has_custom_certificate, content="true")
  inspect(parsed.pending_update_count, content="0")
  inspect(parsed.ip_address, content="Some(\"1.2.3.4\")")
  inspect(parsed.max_connections, content="Some(40)")
  inspect(
    parsed.allowed_updates,
    content="Some([\"message\", \"callback_query\"])",
  )
}

///|
test "WebhookInfo JSON round-trip with error fields" {
  let webhook_info : WebhookInfo = WebhookInfo::new(
    url="https://example.com/webhook",
    has_custom_certificate=false,
    pending_update_count=5,
    last_error_date=1640995200,
    last_error_message="Connection timeout",
    last_synchronization_error_date=1641081600,
  )
  let json = @json.to_json(webhook_info)
  let parsed : WebhookInfo = @json.from_json(json)
  inspect(parsed.url, content="https://example.com/webhook")
  inspect(parsed.has_custom_certificate, content="false")
  inspect(parsed.pending_update_count, content="5")
  inspect(parsed.last_error_date, content="Some(1640995200)")
  inspect(parsed.last_error_message, content="Some(\"Connection timeout\")")
  inspect(
    parsed.last_synchronization_error_date,
    content="Some(1641081600)",
  )
}

///|
test "WebhookInfo JSON round-trip minimal" {
  let webhook_info : WebhookInfo = WebhookInfo::new(
    url="",
    has_custom_certificate=false,
    pending_update_count=0,
  )
  let json = @json.to_json(webhook_info)
  let parsed : WebhookInfo = @json.from_json(json)
  inspect(parsed.url, content="")
  inspect(parsed.has_custom_certificate, content="false")
  inspect(parsed.pending_update_count, content="0")
  inspect(parsed.ip_address, content="None")
  inspect(parsed.last_error_date, content="None")
  inspect(parsed.last_error_message, content="None")
  inspect(parsed.last_synchronization_error_date, content="None")
  inspect(parsed.max_connections, content="None")
  inspect(parsed.allowed_updates, content="None")
}
