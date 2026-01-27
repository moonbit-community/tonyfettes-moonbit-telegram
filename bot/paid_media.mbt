///|
// Placeholder - will be replaced when media types are merged
pub struct PhotoSizePlaceholder {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
} derive(Show, Eq)

///|
pub fn PhotoSizePlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
) -> PhotoSizePlaceholder {
  { file_id, file_unique_id, width, height }
}

///|
pub impl @json.ToJson for PhotoSizePlaceholder with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PhotoSizePlaceholder with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for PhotoSizePlaceholder",
    )
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let width : Int = @json.from_json(obj["width"], path~)
  let height : Int = @json.from_json(obj["height"], path~)
  { file_id, file_unique_id, width, height }
}

///|
// Placeholder - will be replaced when media types are merged
pub struct VideoPlaceholder {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
  duration : Int
} derive(Show, Eq)

///|
pub fn VideoPlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
  duration~ : Int,
) -> VideoPlaceholder {
  { file_id, file_unique_id, width, height, duration }
}

///|
pub impl @json.ToJson for VideoPlaceholder with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
    "duration": @json.to_json(self.duration),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoPlaceholder with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoPlaceholder")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let width : Int = @json.from_json(obj["width"], path~)
  let height : Int = @json.from_json(obj["height"], path~)
  let duration : Int = @json.from_json(obj["duration"], path~)
  { file_id, file_unique_id, width, height, duration }
}

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
  photo : Array[PhotoSizePlaceholder]
} derive(Show, Eq)

///|
pub fn PaidMediaPhoto::new(
  photo~ : Array[PhotoSizePlaceholder],
) -> PaidMediaPhoto {
  { photo, }
}

///|
pub struct PaidMediaVideo {
  video : VideoPlaceholder
} derive(Show, Eq)

///|
pub fn PaidMediaVideo::new(video~ : VideoPlaceholder) -> PaidMediaVideo {
  { video, }
}

///|
pub impl @json.ToJson for PaidMedia with to_json(self) {
  match self {
    Preview(v) => {
      let obj : Map[String, Json] = { "type": "preview" }
      if v.width is Some(w) {
        obj["width"] = @json.to_json(w)
      }
      if v.height is Some(h) {
        obj["height"] = @json.to_json(h)
      }
      if v.duration is Some(d) {
        obj["duration"] = @json.to_json(d)
      }
      @json.to_json(obj)
    }
    Photo(v) => {
      let obj : Map[String, Json] = {
        "type": "photo",
        "photo": @json.to_json(v.photo),
      }
      @json.to_json(obj)
    }
    Video(v) => {
      let obj : Map[String, Json] = {
        "type": "video",
        "video": @json.to_json(v.video),
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for PaidMedia with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for PaidMedia")
  }
  guard obj["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field for PaidMedia")
  }
  match type_ {
    "preview" => {
      let width : Int? = if obj.get("width") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let height : Int? = if obj.get("height") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let duration : Int? = if obj.get("duration") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Preview({ width, height, duration })
    }
    "photo" => Photo({ photo: @json.from_json(obj["photo"], path~) })
    "video" => Video({ video: @json.from_json(obj["video"], path~) })
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
  let obj : Map[String, Json] = {
    "star_count": @json.to_json(self.star_count),
    "paid_media": @json.to_json(self.paid_media),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PaidMediaInfo with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for PaidMediaInfo")
  }
  let star_count : Int = @json.from_json(obj["star_count"], path~)
  let paid_media : Array[PaidMedia] = @json.from_json(obj["paid_media"], path~)
  { star_count, paid_media }
}
