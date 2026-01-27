///|
test "StickerPlaceholder JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique456",
    width=512,
    height=512,
  )
  let json = @json.to_json(sticker)
  let parsed : StickerPlaceholder = @json.from_json(json)
  inspect(parsed.file_id, content="abc123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.width, content="512")
  inspect(parsed.height, content="512")
}

///|
test "Gift JSON round-trip with optional fields" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker123",
    file_unique_id="unique789",
    width=256,
    height=256,
  )
  let gift = Gift::new(
    id="gift001",
    sticker~,
    star_count=100,
    total_count=1000,
    remaining_count=500,
  )
  let json = @json.to_json(gift)
  let parsed : Gift = @json.from_json(json)
  inspect(parsed.id, content="gift001")
  inspect(parsed.star_count, content="100")
  inspect(parsed.total_count, content="Some(1000)")
  inspect(parsed.remaining_count, content="Some(500)")
}

///|
test "Gift JSON round-trip without optional fields" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker456",
    file_unique_id="unique012",
    width=128,
    height=128,
  )
  let gift = Gift::new(id="gift002", sticker~, star_count=50)
  let json = @json.to_json(gift)
  let parsed : Gift = @json.from_json(json)
  inspect(parsed.id, content="gift002")
  inspect(parsed.star_count, content="50")
  inspect(parsed.total_count, content="None")
  inspect(parsed.remaining_count, content="None")
}

///|
test "Gifts JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="sticker789",
    file_unique_id="unique345",
    width=64,
    height=64,
  )
  let gift1 = Gift::new(id="gift003", sticker~, star_count=25)
  let gift2 = Gift::new(id="gift004", sticker~, star_count=75, total_count=500)
  let gifts = Gifts::new(gifts=[gift1, gift2])
  let json = @json.to_json(gifts)
  let parsed : Gifts = @json.from_json(json)
  inspect(parsed.gifts.length(), content="2")
  inspect(parsed.gifts[0].id, content="gift003")
  inspect(parsed.gifts[1].id, content="gift004")
}

///|
test "AcceptedGiftTypes JSON round-trip" {
  let types = AcceptedGiftTypes::new(
    unlimited_gifts=true,
    limited_gifts=false,
    unique_gifts=true,
    premium_subscription=false,
  )
  let json = @json.to_json(types)
  let parsed : AcceptedGiftTypes = @json.from_json(json)
  inspect(parsed.unlimited_gifts, content="true")
  inspect(parsed.limited_gifts, content="false")
  inspect(parsed.unique_gifts, content="true")
  inspect(parsed.premium_subscription, content="false")
}
