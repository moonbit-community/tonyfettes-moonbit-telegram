///|
pub struct VideoNote {
  file_id : String
  file_unique_id : String
  length : Int
  duration : Int
  thumbnail : PhotoSize?
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn VideoNote::new(
  file_id~ : String,
  file_unique_id~ : String,
  length~ : Int,
  duration~ : Int,
  thumbnail? : PhotoSize,
  file_size? : Int64,
) -> VideoNote {
  { file_id, file_unique_id, length, duration, thumbnail, file_size }
}

///|
pub impl @json.ToJson for VideoNote with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "length": @json.to_json(self.length),
    "duration": @json.to_json(self.duration),
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = @json.to_json(v)
  }
  if self.file_size is Some(v) {
    object["file_size"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for VideoNote with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoNote")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let length : Int = @json.from_json(object["length"], path~)
  let duration : Int = @json.from_json(object["duration"], path~)
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { file_id, file_unique_id, length, duration, thumbnail, file_size }
}
