///|
test "GiftInfo JSON round-trip" {
  let sticker = StickerPlaceholder::new(
    file_id="abc123",
    file_unique_id="unique123",
    width=512,
    height=512,
  )
  let gift = Gift::new(id="gift_id_123", sticker~, star_count=100)
  let original = GiftInfo::new(gift~)
  let json = @json.to_json(original)
  let decoded : GiftInfo = @json.from_json(json)
  inspect(decoded.gift.id, content="gift_id_123")
  inspect(decoded.gift.star_count, content="100")
  inspect(decoded.from, content="None")
}

///|
test "GiftInfo ToJson and FromJson with user" {
  let sticker = StickerPlaceholder::new(
    file_id="xyz789",
    file_unique_id="unique789",
    width=256,
    height=256,
  )
  let gift = Gift::new(
    id="gift_id_456",
    sticker~,
    star_count=500,
    total_count=1000,
    remaining_count=500,
  )
  let user = User::new(id=123456789L, is_bot=false, first_name="John")
  let gift_info = GiftInfo::new(gift~, from=user)
  let json = @json.to_json(gift_info)
  let reconstructed : GiftInfo = @json.from_json(json)
  inspect(reconstructed.gift.id, content="gift_id_456")
  inspect(reconstructed.gift.star_count, content="500")
  inspect(reconstructed.from is Some(_), content="true")
}
