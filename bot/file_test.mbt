///|
test "File JSON round-trip" {
  let file = File::new(
    file_id="AgACAgIAAxkBAAI",
    file_unique_id="AQADAgATfile",
    file_size=1024000L,
    file_path="photos/file_0.jpg",
  )
  let json = @json.to_json(file)
  let parsed : File = @json.from_json(json)
  inspect(parsed.file_id, content="AgACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATfile")
  inspect(parsed.file_size, content="Some(1024000)")
  inspect(parsed.file_path, content="Some(\"photos/file_0.jpg\")")
}

///|
test "File JSON round-trip without optionals" {
  let file = File::new(file_id="AgACAgIAAxkBAAI", file_unique_id="AQADAgATfile")
  let json = @json.to_json(file)
  let parsed : File = @json.from_json(json)
  inspect(parsed.file_id, content="AgACAgIAAxkBAAI")
  inspect(parsed.file_size, content="None")
  inspect(parsed.file_path, content="None")
}
