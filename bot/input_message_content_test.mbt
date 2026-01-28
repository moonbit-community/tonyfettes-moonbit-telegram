///|
test "LinkPreviewOptions JSON round-trip" {
  let object = LinkPreviewOptions::new(
    is_disabled=true,
    url="https://example.com",
    prefer_small_media=false,
    prefer_large_media=true,
    show_above_text=false,
  )
  let json = @json.to_json(object)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="Some(true)")
  inspect(parsed.url, content="Some(\"https://example.com\")")
  inspect(parsed.prefer_small_media, content="Some(false)")
  inspect(parsed.prefer_large_media, content="Some(true)")
  inspect(parsed.show_above_text, content="Some(false)")
}

///|
test "LinkPreviewOptions empty JSON round-trip" {
  let object = LinkPreviewOptions::new()
  let json = @json.to_json(object)
  let parsed : LinkPreviewOptions = @json.from_json(json)
  inspect(parsed.is_disabled, content="None")
  inspect(parsed.url, content="None")
}

///|
test "InputTextMessageContent JSON round-trip" {
  let object = InputTextMessageContent::new(
    message_text="Hello, world!",
    parse_mode="HTML",
  )
  let json = @json.to_json(object)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Hello, world!")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.entities, content="None")
  inspect(parsed.link_preview_options, content="None")
}

///|
test "InputTextMessageContent with entities JSON round-trip" {
  let entity = MessageEntity::new(type_="bold", offset=0, length=5)
  let object = InputTextMessageContent::new(message_text="Hello", entities=[
    entity,
  ])
  let json = @json.to_json(object)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Hello")
  guard parsed.entities is Some(entities) else { fail("Expected entities") }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="bold")
}

///|
test "InputTextMessageContent with link_preview_options JSON round-trip" {
  let options = LinkPreviewOptions::new(is_disabled=true)
  let object = InputTextMessageContent::new(
    message_text="Check this out",
    link_preview_options=options,
  )
  let json = @json.to_json(object)
  let parsed : InputTextMessageContent = @json.from_json(json)
  inspect(parsed.message_text, content="Check this out")
  guard parsed.link_preview_options is Some(opts) else {
    fail("Expected link_preview_options")
  }
  inspect(opts.is_disabled, content="Some(true)")
}

///|
test "InputLocationMessageContent JSON round-trip" {
  let object = InputLocationMessageContent::new(
    latitude=40.7128,
    longitude=-74.006,
    horizontal_accuracy=10.5,
    live_period=3600,
    heading=90,
    proximity_alert_radius=100,
  )
  let json = @json.to_json(object)
  let parsed : InputLocationMessageContent = @json.from_json(json)
  inspect(parsed.latitude, content="40.7128")
  inspect(parsed.longitude, content="-74.006")
  inspect(parsed.horizontal_accuracy, content="Some(10.5)")
  inspect(parsed.live_period, content="Some(3600)")
  inspect(parsed.heading, content="Some(90)")
  inspect(parsed.proximity_alert_radius, content="Some(100)")
}

///|
test "InputLocationMessageContent minimal JSON round-trip" {
  let object = InputLocationMessageContent::new(
    latitude=51.5074,
    longitude=-0.1278,
  )
  let json = @json.to_json(object)
  let parsed : InputLocationMessageContent = @json.from_json(json)
  inspect(parsed.latitude, content="51.5074")
  inspect(parsed.longitude, content="-0.1278")
  inspect(parsed.horizontal_accuracy, content="None")
  inspect(parsed.live_period, content="None")
}

///|
test "InputVenueMessageContent JSON round-trip" {
  let object = InputVenueMessageContent::new(
    latitude=40.7484,
    longitude=-73.9857,
    title="Empire State Building",
    address="350 Fifth Avenue, New York",
    foursquare_id="4f5b8b8ee4b08e3e97eb9b3d",
    foursquare_type="building",
    google_place_id="ChIJaXQRs6lZwokRY6EFpJnhNNE",
    google_place_type="point_of_interest",
  )
  let json = @json.to_json(object)
  let parsed : InputVenueMessageContent = @json.from_json(json)
  inspect(parsed.latitude, content="40.7484")
  inspect(parsed.longitude, content="-73.9857")
  inspect(parsed.title, content="Empire State Building")
  inspect(parsed.address, content="350 Fifth Avenue, New York")
  inspect(parsed.foursquare_id, content="Some(\"4f5b8b8ee4b08e3e97eb9b3d\")")
  inspect(parsed.foursquare_type, content="Some(\"building\")")
  inspect(
    parsed.google_place_id,
    content="Some(\"ChIJaXQRs6lZwokRY6EFpJnhNNE\")",
  )
  inspect(parsed.google_place_type, content="Some(\"point_of_interest\")")
}

///|
test "InputVenueMessageContent minimal JSON round-trip" {
  let object = InputVenueMessageContent::new(
    latitude=48.8584,
    longitude=2.2945,
    title="Eiffel Tower",
    address="Champ de Mars, Paris",
  )
  let json = @json.to_json(object)
  let parsed : InputVenueMessageContent = @json.from_json(json)
  inspect(parsed.title, content="Eiffel Tower")
  inspect(parsed.address, content="Champ de Mars, Paris")
  inspect(parsed.foursquare_id, content="None")
  inspect(parsed.google_place_id, content="None")
}

///|
test "InputContactMessageContent JSON round-trip" {
  let object = InputContactMessageContent::new(
    phone_number="+1234567890",
    first_name="John",
    last_name="Doe",
    vcard="BEGIN:VCARD\nVERSION:3.0\nN:Doe;John\nEND:VCARD",
  )
  let json = @json.to_json(object)
  let parsed : InputContactMessageContent = @json.from_json(json)
  inspect(parsed.phone_number, content="+1234567890")
  inspect(parsed.first_name, content="John")
  inspect(parsed.last_name, content="Some(\"Doe\")")
  inspect(
    parsed.vcard,
    content="Some(\"BEGIN:VCARD\\nVERSION:3.0\\nN:Doe;John\\nEND:VCARD\")",
  )
}

///|
test "InputContactMessageContent minimal JSON round-trip" {
  let object = InputContactMessageContent::new(
    phone_number="+9876543210",
    first_name="Jane",
  )
  let json = @json.to_json(object)
  let parsed : InputContactMessageContent = @json.from_json(json)
  inspect(parsed.phone_number, content="+9876543210")
  inspect(parsed.first_name, content="Jane")
  inspect(parsed.last_name, content="None")
  inspect(parsed.vcard, content="None")
}

///|
test "InputInvoiceMessageContent JSON round-trip" {
  let prices = [
    LabeledPrice::new(label="Product", amount=1000),
    LabeledPrice::new(label="Tax", amount=100),
  ]
  let object = InputInvoiceMessageContent::new(
    title="Test Product",
    description="A test product description",
    payload="unique_payload_123",
    provider_token="provider_token_abc",
    currency="USD",
    prices~,
    max_tip_amount=500,
    suggested_tip_amounts=[100, 200, 300],
    provider_data="{\"custom\": \"data\"}",
    photo_url="https://example.com/photo.jpg",
    photo_size=1024,
    photo_width=640,
    photo_height=480,
    need_name=true,
    need_phone_number=true,
    need_email=false,
    need_shipping_address=true,
    send_phone_number_to_provider=false,
    send_email_to_provider=false,
    is_flexible=true,
  )
  let json = @json.to_json(object)
  let parsed : InputInvoiceMessageContent = @json.from_json(json)
  inspect(parsed.title, content="Test Product")
  inspect(parsed.description, content="A test product description")
  inspect(parsed.payload, content="unique_payload_123")
  inspect(parsed.provider_token, content="Some(\"provider_token_abc\")")
  inspect(parsed.currency, content="USD")
  inspect(parsed.prices.length(), content="2")
  inspect(parsed.prices[0].label, content="Product")
  inspect(parsed.prices[0].amount, content="1000")
  inspect(parsed.max_tip_amount, content="Some(500)")
  inspect(parsed.suggested_tip_amounts, content="Some([100, 200, 300])")
  inspect(
    parsed.provider_data,
    content="Some(\"{\\\"custom\\\": \\\"data\\\"}\")",
  )
  inspect(parsed.photo_url, content="Some(\"https://example.com/photo.jpg\")")
  inspect(parsed.photo_size, content="Some(1024)")
  inspect(parsed.photo_width, content="Some(640)")
  inspect(parsed.photo_height, content="Some(480)")
  inspect(parsed.need_name, content="Some(true)")
  inspect(parsed.need_phone_number, content="Some(true)")
  inspect(parsed.need_email, content="Some(false)")
  inspect(parsed.need_shipping_address, content="Some(true)")
  inspect(parsed.send_phone_number_to_provider, content="Some(false)")
  inspect(parsed.send_email_to_provider, content="Some(false)")
  inspect(parsed.is_flexible, content="Some(true)")
}

///|
test "InputInvoiceMessageContent minimal JSON round-trip" {
  let prices = [LabeledPrice::new(label="Item", amount=500)]
  let object = InputInvoiceMessageContent::new(
    title="Simple Product",
    description="A simple product",
    payload="payload_456",
    currency="EUR",
    prices~,
  )
  let json = @json.to_json(object)
  let parsed : InputInvoiceMessageContent = @json.from_json(json)
  inspect(parsed.title, content="Simple Product")
  inspect(parsed.currency, content="EUR")
  inspect(parsed.provider_token, content="None")
  inspect(parsed.max_tip_amount, content="None")
  inspect(parsed.need_name, content="None")
}

///|
test "InputMessageContent Text JSON round-trip" {
  let text_content = InputTextMessageContent::new(message_text="Hello!")
  let object : InputMessageContent = Text(text_content)
  let json = @json.to_json(object)
  let parsed : InputMessageContent = @json.from_json(json)
  guard parsed is Text(v) else { fail("Expected Text") }
  inspect(v.message_text, content="Hello!")
}

///|
test "InputMessageContent Location JSON round-trip" {
  let location_content = InputLocationMessageContent::new(
    latitude=35.6762,
    longitude=139.6503,
  )
  let object : InputMessageContent = Location(location_content)
  let json = @json.to_json(object)
  let parsed : InputMessageContent = @json.from_json(json)
  guard parsed is Location(v) else { fail("Expected Location") }
  inspect(v.latitude, content="35.6762")
  inspect(v.longitude, content="139.6503")
}

///|
test "InputMessageContent Venue JSON round-trip" {
  let venue_content = InputVenueMessageContent::new(
    latitude=35.6762,
    longitude=139.6503,
    title="Tokyo Tower",
    address="4 Chome-2-8 Shibakoen, Minato City, Tokyo",
  )
  let object : InputMessageContent = Venue(venue_content)
  let json = @json.to_json(object)
  let parsed : InputMessageContent = @json.from_json(json)
  guard parsed is Venue(v) else { fail("Expected Venue") }
  inspect(v.title, content="Tokyo Tower")
  inspect(v.address, content="4 Chome-2-8 Shibakoen, Minato City, Tokyo")
}

///|
test "InputMessageContent Contact JSON round-trip" {
  let contact_content = InputContactMessageContent::new(
    phone_number="+81123456789",
    first_name="Taro",
  )
  let object : InputMessageContent = Contact(contact_content)
  let json = @json.to_json(object)
  let parsed : InputMessageContent = @json.from_json(json)
  guard parsed is Contact(v) else { fail("Expected Contact") }
  inspect(v.phone_number, content="+81123456789")
  inspect(v.first_name, content="Taro")
}

///|
test "InputMessageContent Invoice JSON round-trip" {
  let prices = [LabeledPrice::new(label="Service", amount=2000)]
  let invoice_content = InputInvoiceMessageContent::new(
    title="Premium Service",
    description="Premium service subscription",
    payload="service_payload",
    currency="JPY",
    prices~,
  )
  let object : InputMessageContent = Invoice(invoice_content)
  let json = @json.to_json(object)
  let parsed : InputMessageContent = @json.from_json(json)
  guard parsed is Invoice(v) else { fail("Expected Invoice") }
  inspect(v.title, content="Premium Service")
  inspect(v.currency, content="JPY")
  inspect(v.prices.length(), content="1")
}
