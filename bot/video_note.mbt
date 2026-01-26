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
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "length": @json.to_json(self.length),
    "duration": @json.to_json(self.duration),
  }
  if self.thumbnail is Some(v) {
    obj["thumbnail"] = @json.to_json(v)
  }
  if self.file_size is Some(v) {
    obj["file_size"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoNote with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoNote")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let length : Int = @json.from_json(obj["length"], path~)
  let duration : Int = @json.from_json(obj["duration"], path~)
  let thumbnail : PhotoSize? = if obj.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if obj.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { file_id, file_unique_id, length, duration, thumbnail, file_size }
}
