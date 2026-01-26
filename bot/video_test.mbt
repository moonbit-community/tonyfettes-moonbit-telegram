///|
test "Video JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let cover_photo = PhotoSize::new(
    file_id="cover_id",
    file_unique_id="cover_unique",
    width=1280,
    height=720,
  )
  let video = Video::new(
    file_id="BAACAgIAAxkBAAI",
    file_unique_id="AQADAgATvideo",
    width=1920,
    height=1080,
    duration=120,
    thumbnail~,
    cover=[cover_photo],
    start_timestamp=10,
    file_name="video.mp4",
    mime_type="video/mp4",
    file_size=15000000L,
  )
  let json = @json.to_json(video)
  let parsed : Video = @json.from_json(json)
  inspect(parsed.file_id, content="BAACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATvideo")
  inspect(parsed.width, content="1920")
  inspect(parsed.height, content="1080")
  inspect(parsed.duration, content="120")
  inspect(parsed.start_timestamp, content="Some(10)")
  inspect(parsed.file_name, content="Some(\"video.mp4\")")
  inspect(parsed.mime_type, content="Some(\"video/mp4\")")
  inspect(parsed.file_size, content="Some(15000000)")
}

///|
test "Video JSON round-trip without optionals" {
  let video = Video::new(
    file_id="BAACAgIAAxkBAAI",
    file_unique_id="AQADAgATvideo",
    width=1920,
    height=1080,
    duration=120,
  )
  let json = @json.to_json(video)
  let parsed : Video = @json.from_json(json)
  inspect(parsed.file_id, content="BAACAgIAAxkBAAI")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.cover, content="None")
  inspect(parsed.start_timestamp, content="None")
}
