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
pub struct UniqueGiftColors {
  background_icon_color : Int
  text_color : Int
  hint_color : Int
  link_color : Int
  button_color : Int
  button_text_color : Int
} derive(Show, Eq)

///|
pub fn UniqueGiftColors::new(
  background_icon_color~ : Int,
  text_color~ : Int,
  hint_color~ : Int,
  link_color~ : Int,
  button_color~ : Int,
  button_text_color~ : Int,
) -> UniqueGiftColors {
  {
    background_icon_color,
    text_color,
    hint_color,
    link_color,
    button_color,
    button_text_color,
  }
}

///|
pub impl @json.ToJson for UniqueGiftColors with to_json(self) {
  let object : Map[String, Json] = {
    "background_icon_color": @json.to_json(self.background_icon_color),
    "text_color": @json.to_json(self.text_color),
    "hint_color": @json.to_json(self.hint_color),
    "link_color": @json.to_json(self.link_color),
    "button_color": @json.to_json(self.button_color),
    "button_text_color": @json.to_json(self.button_text_color),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for UniqueGiftColors with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for UniqueGiftColors")
  }
  let background_icon_color : Int = @json.from_json(
    object["background_icon_color"],
    path~,
  )
  let text_color : Int = @json.from_json(object["text_color"], path~)
  let hint_color : Int = @json.from_json(object["hint_color"], path~)
  let link_color : Int = @json.from_json(object["link_color"], path~)
  let button_color : Int = @json.from_json(object["button_color"], path~)
  let button_text_color : Int = @json.from_json(
    object["button_text_color"],
    path~,
  )
  {
    background_icon_color,
    text_color,
    hint_color,
    link_color,
    button_color,
    button_text_color,
  }
}

///|
pub struct GiftBackground {
  type_ : String
  fill_color : Int?
  gradient_top_color : Int?
  gradient_bottom_color : Int?
} derive(Show, Eq)

///|
pub fn GiftBackground::new(
  type_~ : String,
  fill_color? : Int,
  gradient_top_color? : Int,
  gradient_bottom_color? : Int,
) -> GiftBackground {
  { type_, fill_color, gradient_top_color, gradient_bottom_color }
}

///|
pub impl @json.ToJson for GiftBackground with to_json(self) {
  let object : Map[String, Json] = { "type": @json.to_json(self.type_) }
  if self.fill_color is Some(v) {
    object["fill_color"] = @json.to_json(v)
  }
  if self.gradient_top_color is Some(v) {
    object["gradient_top_color"] = @json.to_json(v)
  }
  if self.gradient_bottom_color is Some(v) {
    object["gradient_bottom_color"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for GiftBackground with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for GiftBackground")
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let fill_color : Int? = if object.get("fill_color") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gradient_top_color : Int? = if object.get("gradient_top_color") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gradient_bottom_color : Int? = if object.get("gradient_bottom_color")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, fill_color, gradient_top_color, gradient_bottom_color }
}

///|
pub struct Gift {
  id : String
  sticker : StickerPlaceholder
  star_count : Int
  total_count : Int?
  remaining_count : Int?
  publisher_chat : Chat?
  colors : UniqueGiftColors?
  background : GiftBackground?
  unique_gift_variant_count : Int?
  unique_gift_number : Int?
  gifts_from_channels : Bool?
  is_premium : Bool?
  has_colors : Bool?
} derive(Show, Eq)

///|
pub fn Gift::new(
  id~ : String,
  sticker~ : StickerPlaceholder,
  star_count~ : Int,
  total_count? : Int,
  remaining_count? : Int,
  publisher_chat? : Chat,
  colors? : UniqueGiftColors,
  background? : GiftBackground,
  unique_gift_variant_count? : Int,
  unique_gift_number? : Int,
  gifts_from_channels? : Bool,
  is_premium? : Bool,
  has_colors? : Bool,
) -> Gift {
  {
    id,
    sticker,
    star_count,
    total_count,
    remaining_count,
    publisher_chat,
    colors,
    background,
    unique_gift_variant_count,
    unique_gift_number,
    gifts_from_channels,
    is_premium,
    has_colors,
  }
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
  if self.publisher_chat is Some(v) {
    object["publisher_chat"] = @json.to_json(v)
  }
  if self.colors is Some(v) {
    object["colors"] = @json.to_json(v)
  }
  if self.background is Some(v) {
    object["background"] = @json.to_json(v)
  }
  if self.unique_gift_variant_count is Some(v) {
    object["unique_gift_variant_count"] = @json.to_json(v)
  }
  if self.unique_gift_number is Some(v) {
    object["unique_gift_number"] = @json.to_json(v)
  }
  if self.gifts_from_channels is Some(v) {
    object["gifts_from_channels"] = @json.to_json(v)
  }
  if self.is_premium is Some(v) {
    object["is_premium"] = @json.to_json(v)
  }
  if self.has_colors is Some(v) {
    object["has_colors"] = @json.to_json(v)
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
  let publisher_chat : Chat? = if object.get("publisher_chat") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let colors : UniqueGiftColors? = if object.get("colors") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let background : GiftBackground? = if object.get("background") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let unique_gift_variant_count : Int? = if object.get(
      "unique_gift_variant_count",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let unique_gift_number : Int? = if object.get("unique_gift_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gifts_from_channels : Bool? = if object.get("gifts_from_channels")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_premium : Bool? = if object.get("is_premium") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_colors : Bool? = if object.get("has_colors") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    id,
    sticker,
    star_count,
    total_count,
    remaining_count,
    publisher_chat,
    colors,
    background,
    unique_gift_variant_count,
    unique_gift_number,
    gifts_from_channels,
    is_premium,
    has_colors,
  }
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
  let object : Map[String, Json] = {
    "gifts": @json.ToJson::to_json(self.gifts),
  }
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

///|
pub struct UniqueGiftInfo {
  next_transfer_date : Int?
  last_resale_amount : Int?
  origin : String?
  gift_id : String
  is_from_blockchain : Bool?
} derive(Show, Eq)

///|
pub fn UniqueGiftInfo::new(
  gift_id~ : String,
  next_transfer_date? : Int,
  last_resale_amount? : Int,
  origin? : String,
  is_from_blockchain? : Bool,
) -> UniqueGiftInfo {
  {
    gift_id,
    next_transfer_date,
    last_resale_amount,
    origin,
    is_from_blockchain,
  }
}

///|
pub impl @json.ToJson for UniqueGiftInfo with to_json(self) {
  let object : Map[String, Json] = { "gift_id": @json.to_json(self.gift_id) }
  if self.next_transfer_date is Some(v) {
    object["next_transfer_date"] = @json.to_json(v)
  }
  if self.last_resale_amount is Some(v) {
    object["last_resale_amount"] = @json.to_json(v)
  }
  if self.origin is Some(v) {
    object["origin"] = @json.to_json(v)
  }
  if self.is_from_blockchain is Some(v) {
    object["is_from_blockchain"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for UniqueGiftInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for UniqueGiftInfo")
  }
  let gift_id : String = @json.from_json(object["gift_id"], path~)
  let next_transfer_date : Int? = if object.get("next_transfer_date") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_resale_amount : Int? = if object.get("last_resale_amount")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let origin : String? = if object.get("origin") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_from_blockchain : Bool? = if object.get("is_from_blockchain")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    gift_id,
    next_transfer_date,
    last_resale_amount,
    origin,
    is_from_blockchain,
  }
}

///|
pub struct StarBalance {
  balance : Int
} derive(Show, Eq)

///|
pub fn StarBalance::new(balance~ : Int) -> StarBalance {
  { balance, }
}

///|
pub impl @json.ToJson for StarBalance with to_json(self) {
  let object : Map[String, Json] = {
    "balance": @json.to_json(self.balance),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for StarBalance with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for StarBalance")
  }
  let balance : Int = @json.from_json(object["balance"], path~)
  { balance, }
}

