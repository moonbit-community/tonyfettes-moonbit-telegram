///|
test "VideoNote JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let video_note = VideoNote::new(
    file_id="DQACAgIAAxkBAAI",
    file_unique_id="AQADAgATvnote",
    length=240,
    duration=30,
    thumbnail~,
    file_size=500000L,
  )
  let json = @json.to_json(video_note)
  let parsed : VideoNote = @json.from_json(json)
  inspect(parsed.file_id, content="DQACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATvnote")
  inspect(parsed.length, content="240")
  inspect(parsed.duration, content="30")
  inspect(parsed.file_size, content="Some(500000)")
}

///|
test "VideoNote JSON round-trip without optionals" {
  let video_note = VideoNote::new(
    file_id="DQACAgIAAxkBAAI",
    file_unique_id="AQADAgATvnote",
    length=240,
    duration=30,
  )
  let json = @json.to_json(video_note)
  let parsed : VideoNote = @json.from_json(json)
  inspect(parsed.file_id, content="DQACAgIAAxkBAAI")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.file_size, content="None")
}
