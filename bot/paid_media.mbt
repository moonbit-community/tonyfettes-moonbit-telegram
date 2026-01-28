///|
pub(all) enum PaidMedia {
  Preview(PaidMediaPreview)
  Photo(PaidMediaPhoto)
  Video(PaidMediaVideo)
} derive(Show, Eq)

///|
pub struct PaidMediaPreview {
  width : Int?
  height : Int?
  duration : Int?
} derive(Show, Eq)

///|
pub fn PaidMediaPreview::new(
  width? : Int,
  height? : Int,
  duration? : Int,
) -> PaidMediaPreview {
  { width, height, duration }
}

///|
pub struct PaidMediaPhoto {
  photo : Array[PhotoSize]
} derive(Show, Eq)

///|
pub fn PaidMediaPhoto::new(photo~ : Array[PhotoSize]) -> PaidMediaPhoto {
  { photo, }
}

///|
pub struct PaidMediaVideo {
  video : Video
} derive(Show, Eq)

///|
pub fn PaidMediaVideo::new(video~ : Video) -> PaidMediaVideo {
  { video, }
}

///|
pub impl @json.ToJson for PaidMedia with to_json(self) {
  match self {
    Preview(v) => {
      let object : Map[String, Json] = { "type": "preview" }
      if v.width is Some(w) {
        object["width"] = @json.to_json(w)
      }
      if v.height is Some(h) {
        object["height"] = @json.to_json(h)
      }
      if v.duration is Some(d) {
        object["duration"] = @json.to_json(d)
      }
      @json.to_json(object)
    }
    Photo(v) => {
      let object : Map[String, Json] = {
        "type": "photo",
        "photo": @json.to_json(v.photo),
      }
      @json.to_json(object)
    }
    Video(v) => {
      let object : Map[String, Json] = {
        "type": "video",
        "video": @json.to_json(v.video),
      }
      @json.to_json(object)
    }
  }
}

///|
pub impl @json.FromJson for PaidMedia with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for PaidMedia")
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field for PaidMedia")
  }
  match type_ {
    "preview" => {
      let width : Int? = if object.get("width") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let height : Int? = if object.get("height") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let duration : Int? = if object.get("duration") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Preview({ width, height, duration })
    }
    "photo" => Photo({ photo: @json.from_json(object["photo"], path~) })
    "video" => Video({ video: @json.from_json(object["video"], path~) })
    _ => raise @json.JsonDecodeError(path~, "Unknown PaidMedia type")
  }
}

///|
pub struct PaidMediaInfo {
  star_count : Int
  paid_media : Array[PaidMedia]
} derive(Show, Eq)

///|
pub fn PaidMediaInfo::new(
  star_count~ : Int,
  paid_media~ : Array[PaidMedia],
) -> PaidMediaInfo {
  { star_count, paid_media }
}

///|
pub impl @json.ToJson for PaidMediaInfo with to_json(self) {
  let object : Map[String, Json] = {
    "star_count": @json.to_json(self.star_count),
    "paid_media": @json.to_json(self.paid_media),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for PaidMediaInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for PaidMediaInfo")
  }
  let star_count : Int = @json.from_json(object["star_count"], path~)
  let paid_media : Array[PaidMedia] = @json.from_json(object["paid_media"], path~)
  { star_count, paid_media }
}
