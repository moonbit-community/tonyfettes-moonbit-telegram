///|
test "Animation JSON round-trip" {
  let thumbnail = PhotoSize::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=90,
    height=90,
  )
  let animation = Animation::new(
    file_id="CgACAgIAAxkBAAI",
    file_unique_id="AQADAgATanim",
    width=480,
    height=360,
    duration=5,
    thumbnail~,
    file_name="animation.gif",
    mime_type="image/gif",
    file_size=256000L,
  )
  let json = @json.to_json(animation)
  let parsed : Animation = @json.from_json(json)
  inspect(parsed.file_id, content="CgACAgIAAxkBAAI")
  inspect(parsed.file_unique_id, content="AQADAgATanim")
  inspect(parsed.width, content="480")
  inspect(parsed.height, content="360")
  inspect(parsed.duration, content="5")
  inspect(parsed.file_name, content="Some(\"animation.gif\")")
  inspect(parsed.mime_type, content="Some(\"image/gif\")")
  inspect(parsed.file_size, content="Some(256000)")
}

///|
test "Animation JSON round-trip without optionals" {
  let animation = Animation::new(
    file_id="CgACAgIAAxkBAAI",
    file_unique_id="AQADAgATanim",
    width=480,
    height=360,
    duration=5,
  )
  let json = @json.to_json(animation)
  let parsed : Animation = @json.from_json(json)
  inspect(parsed.file_id, content="CgACAgIAAxkBAAI")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.file_name, content="None")
}
