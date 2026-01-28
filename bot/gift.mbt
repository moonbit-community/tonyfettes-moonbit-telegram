///|
pub struct StickerPlaceholder {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
} derive(Show, Eq)

///|
pub fn StickerPlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
) -> StickerPlaceholder {
  { file_id, file_unique_id, width, height }
}

///|
pub impl @json.ToJson for StickerPlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for StickerPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for StickerPlaceholder")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let width : Int = @json.from_json(object["width"], path~)
  let height : Int = @json.from_json(object["height"], path~)
  { file_id, file_unique_id, width, height }
}

///|
pub struct Gift {
  id : String
  sticker : StickerPlaceholder
  star_count : Int
  total_count : Int?
  remaining_count : Int?
} derive(Show, Eq)

///|
pub fn Gift::new(
  id~ : String,
  sticker~ : StickerPlaceholder,
  star_count~ : Int,
  total_count? : Int,
  remaining_count? : Int,
) -> Gift {
  { id, sticker, star_count, total_count, remaining_count }
}

///|
pub impl @json.ToJson for Gift with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "sticker": @json.to_json(self.sticker),
    "star_count": @json.to_json(self.star_count),
  }
  if self.total_count is Some(v) {
    object["total_count"] = @json.to_json(v)
  }
  if self.remaining_count is Some(v) {
    object["remaining_count"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Gift with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Gift")
  }
  let id : String = @json.from_json(object["id"], path~)
  let sticker : StickerPlaceholder = @json.from_json(object["sticker"], path~)
  let star_count : Int = @json.from_json(object["star_count"], path~)
  let total_count : Int? = if object.get("total_count") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let remaining_count : Int? = if object.get("remaining_count") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, sticker, star_count, total_count, remaining_count }
}

///|
pub struct Gifts {
  gifts : Array[Gift]
} derive(Show, Eq)

///|
pub fn Gifts::new(gifts~ : Array[Gift]) -> Gifts {
  { gifts, }
}

///|
pub impl @json.ToJson for Gifts with to_json(self) {
  let object : Map[String, Json] = { "gifts": @json.ToJson::to_json(self.gifts) }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Gifts with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Gifts")
  }
  let gifts : Array[Gift] = @json.from_json(object["gifts"], path~)
  { gifts, }
}

///|
pub struct AcceptedGiftTypes {
  unlimited_gifts : Bool
  limited_gifts : Bool
  unique_gifts : Bool
  premium_subscription : Bool
} derive(Show, Eq)

///|
pub fn AcceptedGiftTypes::new(
  unlimited_gifts~ : Bool,
  limited_gifts~ : Bool,
  unique_gifts~ : Bool,
  premium_subscription~ : Bool,
) -> AcceptedGiftTypes {
  { unlimited_gifts, limited_gifts, unique_gifts, premium_subscription }
}

///|
pub impl @json.ToJson for AcceptedGiftTypes with to_json(self) {
  let object : Map[String, Json] = {
    "unlimited_gifts": @json.to_json(self.unlimited_gifts),
    "limited_gifts": @json.to_json(self.limited_gifts),
    "unique_gifts": @json.to_json(self.unique_gifts),
    "premium_subscription": @json.to_json(self.premium_subscription),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for AcceptedGiftTypes with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for AcceptedGiftTypes")
  }
  let unlimited_gifts : Bool = @json.from_json(object["unlimited_gifts"], path~)
  let limited_gifts : Bool = @json.from_json(object["limited_gifts"], path~)
  let unique_gifts : Bool = @json.from_json(object["unique_gifts"], path~)
  let premium_subscription : Bool = @json.from_json(
    object["premium_subscription"],
    path~,
  )
  { unlimited_gifts, limited_gifts, unique_gifts, premium_subscription }
}
