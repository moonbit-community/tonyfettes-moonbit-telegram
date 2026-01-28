///|
pub struct FilePlaceholder {
  file_id : String
  file_unique_id : String
} derive(Show, Eq)

///|
pub fn FilePlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
) -> FilePlaceholder {
  { file_id, file_unique_id }
}

///|
pub impl @json.ToJson for FilePlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for FilePlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for FilePlaceholder")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  { file_id, file_unique_id }
}

///|
pub struct MaskPosition {
  point : String
  x_shift : Double
  y_shift : Double
  scale : Double
} derive(Show, Eq)

///|
pub fn MaskPosition::new(
  point~ : String,
  x_shift~ : Double,
  y_shift~ : Double,
  scale~ : Double,
) -> MaskPosition {
  { point, x_shift, y_shift, scale }
}

///|
pub impl @json.ToJson for MaskPosition with to_json(self) {
  let object : Map[String, Json] = {
    "point": @json.to_json(self.point),
    "x_shift": @json.to_json(self.x_shift),
    "y_shift": @json.to_json(self.y_shift),
    "scale": @json.to_json(self.scale),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for MaskPosition with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for MaskPosition")
  }
  let point : String = @json.from_json(object["point"], path~)
  let x_shift : Double = @json.from_json(object["x_shift"], path~)
  let y_shift : Double = @json.from_json(object["y_shift"], path~)
  let scale : Double = @json.from_json(object["scale"], path~)
  { point, x_shift, y_shift, scale }
}

///|
pub struct Sticker {
  file_id : String
  file_unique_id : String
  type_ : String
  width : Int
  height : Int
  is_animated : Bool
  is_video : Bool
  thumbnail : PhotoSize?
  emoji : String?
  set_name : String?
  premium_animation : FilePlaceholder?
  mask_position : MaskPosition?
  custom_emoji_id : String?
  needs_repainting : Bool?
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn Sticker::new(
  file_id~ : String,
  file_unique_id~ : String,
  type_~ : String,
  width~ : Int,
  height~ : Int,
  is_animated~ : Bool,
  is_video~ : Bool,
  thumbnail? : PhotoSize,
  emoji? : String,
  set_name? : String,
  premium_animation? : FilePlaceholder,
  mask_position? : MaskPosition,
  custom_emoji_id? : String,
  needs_repainting? : Bool,
  file_size? : Int64,
) -> Sticker {
  {
    file_id,
    file_unique_id,
    type_,
    width,
    height,
    is_animated,
    is_video,
    thumbnail,
    emoji,
    set_name,
    premium_animation,
    mask_position,
    custom_emoji_id,
    needs_repainting,
    file_size,
  }
}

///|
pub impl @json.ToJson for Sticker with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "type": @json.to_json(self.type_),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
    "is_animated": @json.to_json(self.is_animated),
    "is_video": @json.to_json(self.is_video),
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = @json.to_json(v)
  }
  if self.emoji is Some(v) {
    object["emoji"] = @json.to_json(v)
  }
  if self.set_name is Some(v) {
    object["set_name"] = @json.to_json(v)
  }
  if self.premium_animation is Some(v) {
    object["premium_animation"] = @json.to_json(v)
  }
  if self.mask_position is Some(v) {
    object["mask_position"] = @json.to_json(v)
  }
  if self.custom_emoji_id is Some(v) {
    object["custom_emoji_id"] = @json.to_json(v)
  }
  if self.needs_repainting is Some(v) {
    object["needs_repainting"] = @json.to_json(v)
  }
  if self.file_size is Some(v) {
    object["file_size"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Sticker with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Sticker")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let type_ : String = @json.from_json(object["type"], path~)
  let width : Int = @json.from_json(object["width"], path~)
  let height : Int = @json.from_json(object["height"], path~)
  let is_animated : Bool = @json.from_json(object["is_animated"], path~)
  let is_video : Bool = @json.from_json(object["is_video"], path~)
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let emoji : String? = if object.get("emoji") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let set_name : String? = if object.get("set_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let premium_animation : FilePlaceholder? = if object.get("premium_animation")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let mask_position : MaskPosition? = if object.get("mask_position") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let custom_emoji_id : String? = if object.get("custom_emoji_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let needs_repainting : Bool? = if object.get("needs_repainting") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    file_id,
    file_unique_id,
    type_,
    width,
    height,
    is_animated,
    is_video,
    thumbnail,
    emoji,
    set_name,
    premium_animation,
    mask_position,
    custom_emoji_id,
    needs_repainting,
    file_size,
  }
}

///|
pub struct StickerSet {
  name : String
  title : String
  sticker_type : String
  stickers : Array[Sticker]
  thumbnail : PhotoSize?
} derive(Show, Eq)

///|
pub fn StickerSet::new(
  name~ : String,
  title~ : String,
  sticker_type~ : String,
  stickers~ : Array[Sticker],
  thumbnail? : PhotoSize,
) -> StickerSet {
  { name, title, sticker_type, stickers, thumbnail }
}

///|
pub impl @json.ToJson for StickerSet with to_json(self) {
  let object : Map[String, Json] = {
    "name": @json.to_json(self.name),
    "title": @json.to_json(self.title),
    "sticker_type": @json.to_json(self.sticker_type),
    "stickers": @json.to_json(self.stickers),
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for StickerSet with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for StickerSet")
  }
  let name : String = @json.from_json(object["name"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let sticker_type : String = @json.from_json(object["sticker_type"], path~)
  let stickers : Array[Sticker] = @json.from_json(object["stickers"], path~)
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { name, title, sticker_type, stickers, thumbnail }
}

///|
pub struct InputSticker {
  sticker : String
  format : String
  emoji_list : Array[String]
  mask_position : MaskPosition?
  keywords : Array[String]?
} derive(Show, Eq)

///|
pub fn InputSticker::new(
  sticker~ : String,
  format~ : String,
  emoji_list~ : Array[String],
  mask_position? : MaskPosition,
  keywords? : Array[String],
) -> InputSticker {
  { sticker, format, emoji_list, mask_position, keywords }
}

///|
pub impl @json.ToJson for InputSticker with to_json(self) {
  let object : Map[String, Json] = {
    "sticker": @json.to_json(self.sticker),
    "format": @json.to_json(self.format),
    "emoji_list": @json.to_json(self.emoji_list),
  }
  if self.mask_position is Some(v) {
    object["mask_position"] = @json.to_json(v)
  }
  if self.keywords is Some(v) {
    object["keywords"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InputSticker with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for InputSticker")
  }
  let sticker : String = @json.from_json(object["sticker"], path~)
  let format : String = @json.from_json(object["format"], path~)
  let emoji_list : Array[String] = @json.from_json(object["emoji_list"], path~)
  let mask_position : MaskPosition? = if object.get("mask_position") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let keywords : Array[String]? = if object.get("keywords") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { sticker, format, emoji_list, mask_position, keywords }
}
