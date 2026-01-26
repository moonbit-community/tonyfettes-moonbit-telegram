///|
test "Document JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let document = Document::new(
    file_id="BQACAgIAAxkBAAI",
    file_unique_id="AQADAgATdoc",
    thumbnail~,
    file_name="document.pdf",
    mime_type="application/pdf",
    file_size=1024000L,
  )
  let json = @json.to_json(document)
  let parsed : Document = @json.from_json(json)
  inspect(parsed.file_id, content="BQACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATdoc")
  inspect(parsed.file_name, content="Some(\"document.pdf\")")
  inspect(parsed.mime_type, content="Some(\"application/pdf\")")
  inspect(parsed.file_size, content="Some(1024000)")
}

///|
test "Document JSON round-trip without optionals" {
  let document = Document::new(
    file_id="BQACAgIAAxkBAAI",
    file_unique_id="AQADAgATdoc",
  )
  let json = @json.to_json(document)
  let parsed : Document = @json.from_json(json)
  inspect(parsed.file_id, content="BQACAgIAAxkBAAI")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.file_name, content="None")
}
