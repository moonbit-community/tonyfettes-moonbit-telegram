///|
test "ChatPhoto JSON round-trip" {
  let object = ChatPhoto::new(
    small_file_id="small123",
    small_file_unique_id="smalluniq123",
    big_file_id="big123",
    big_file_unique_id="biguniq123",
  )
  let json = @json.to_json(object)
  let parsed : ChatPhoto = @json.from_json(json)
  inspect(parsed.small_file_id, content="small123")
  inspect(parsed.big_file_id, content="big123")
}
