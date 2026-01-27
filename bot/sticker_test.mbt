///|
test "PhotoSizePlaceholder JSON round-trip" {
  let photo = PhotoSizePlaceholder::new(
    file_id="photo123",
    file_unique_id="unique456",
    width=100,
    height=200,
  )
  let json = @json.to_json(photo)
  let parsed : PhotoSizePlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="photo123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.width, content="100")
  inspect(parsed.height, content="200")
}

///|
test "FilePlaceholder JSON round-trip" {
  let file = FilePlaceholder::new(file_id="file123", file_unique_id="unique789")
  let json = @json.to_json(file)
  let parsed : FilePlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="file123")
  inspect(parsed.file_unique_id, content="unique789")
}

///|
test "MaskPosition JSON round-trip" {
  let mask = MaskPosition::new(
    point="forehead",
    x_shift=0.5,
    y_shift=-0.3,
    scale=1.2,
  )
  let json = @json.to_json(mask)
  let parsed : MaskPosition = @json.from_json(json)
  inspect(parsed.point, content="forehead")
  inspect(parsed.x_shift, content="0.5")
  inspect(parsed.y_shift, content="-0.3")
  inspect(parsed.scale, content="1.2")
}

///|
test "Sticker JSON round-trip minimal" {
  let sticker = Sticker::new(
    file_id="sticker123",
    file_unique_id="unique456",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
  )
  let json = @json.to_json(sticker)
  let parsed : Sticker = @json.from_json(json)
  inspect(parsed.file_id, content="sticker123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.type_, content="regular")
  inspect(parsed.width, content="512")
  inspect(parsed.height, content="512")
  inspect(parsed.is_animated, content="false")
  inspect(parsed.is_video, content="false")
  inspect(parsed.thumbnail, content="None")
  inspect(parsed.emoji, content="None")
}

///|
test "Sticker JSON round-trip with optionals" {
  let thumbnail = PhotoSizePlaceholder::new(
    file_id="thumb123",
    file_unique_id="thumbunique",
    width=128,
    height=128,
  )
  let mask = MaskPosition::new(
    point="eyes",
    x_shift=0.0,
    y_shift=0.1,
    scale=1.0,
  )
  let sticker = Sticker::new(
    file_id="sticker456",
    file_unique_id="unique789",
    type_="mask",
    width=512,
    height=512,
    is_animated=true,
    is_video=false,
    thumbnail~,
    emoji="U+1F600",
    set_name="my_sticker_set",
    mask_position=mask,
    file_size=12345L,
  )
  let json = @json.to_json(sticker)
  let parsed : Sticker = @json.from_json(json)
  inspect(parsed.file_id, content="sticker456")
  inspect(parsed.type_, content="mask")
  inspect(parsed.is_animated, content="true")
  inspect(parsed.emoji, content="Some(\"U+1F600\")")
  inspect(parsed.set_name, content="Some(\"my_sticker_set\")")
  inspect(parsed.file_size, content="Some(12345)")
  guard parsed.thumbnail is Some(t) else { fail("Expected thumbnail") }
  inspect(t.file_id, content="thumb123")
  guard parsed.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="eyes")
}

///|
test "StickerSet JSON round-trip" {
  let sticker1 = Sticker::new(
    file_id="s1",
    file_unique_id="u1",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
    emoji="U+1F60A",
  )
  let sticker2 = Sticker::new(
    file_id="s2",
    file_unique_id="u2",
    type_="regular",
    width=512,
    height=512,
    is_animated=false,
    is_video=false,
    emoji="U+1F60B",
  )
  let set = StickerSet::new(
    name="test_sticker_set",
    title="Test Sticker Set",
    sticker_type="regular",
    stickers=[sticker1, sticker2],
  )
  let json = @json.to_json(set)
  let parsed : StickerSet = @json.from_json(json)
  inspect(parsed.name, content="test_sticker_set")
  inspect(parsed.title, content="Test Sticker Set")
  inspect(parsed.sticker_type, content="regular")
  inspect(parsed.stickers.length(), content="2")
  inspect(parsed.thumbnail, content="None")
}

///|
test "StickerSet JSON round-trip with thumbnail" {
  let sticker = Sticker::new(
    file_id="s1",
    file_unique_id="u1",
    type_="custom_emoji",
    width=100,
    height=100,
    is_animated=true,
    is_video=false,
  )
  let thumb = PhotoSizePlaceholder::new(
    file_id="thumb_id",
    file_unique_id="thumb_unique",
    width=64,
    height=64,
  )
  let set = StickerSet::new(
    name="emoji_set",
    title="Emoji Set",
    sticker_type="custom_emoji",
    stickers=[sticker],
    thumbnail=thumb,
  )
  let json = @json.to_json(set)
  let parsed : StickerSet = @json.from_json(json)
  inspect(parsed.name, content="emoji_set")
  inspect(parsed.sticker_type, content="custom_emoji")
  guard parsed.thumbnail is Some(t) else { fail("Expected thumbnail") }
  inspect(t.file_id, content="thumb_id")
}

///|
test "InputSticker JSON round-trip minimal" {
  let input = InputSticker::new(sticker="CAACAgIAAxkBAAI...", format="static", emoji_list=[
    "U+1F600", "U+1F601",
  ])
  let json = @json.to_json(input)
  let parsed : InputSticker = @json.from_json(json)
  inspect(parsed.sticker, content="CAACAgIAAxkBAAI...")
  inspect(parsed.format, content="static")
  inspect(parsed.emoji_list.length(), content="2")
  inspect(parsed.mask_position, content="None")
  inspect(parsed.keywords, content="None")
}

///|
test "InputSticker JSON round-trip with optionals" {
  let mask = MaskPosition::new(
    point="chin",
    x_shift=0.2,
    y_shift=0.3,
    scale=0.9,
  )
  let input = InputSticker::new(
    sticker="https://example.com/sticker.webp",
    format="animated",
    emoji_list=["U+1F923"],
    mask_position=mask,
    keywords=["funny", "laugh", "lol"],
  )
  let json = @json.to_json(input)
  let parsed : InputSticker = @json.from_json(json)
  inspect(parsed.sticker, content="https://example.com/sticker.webp")
  inspect(parsed.format, content="animated")
  guard parsed.mask_position is Some(m) else { fail("Expected mask_position") }
  inspect(m.point, content="chin")
  guard parsed.keywords is Some(kw) else { fail("Expected keywords") }
  inspect(kw.length(), content="3")
  inspect(kw[0], content="funny")
}
