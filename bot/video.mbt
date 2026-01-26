///|
pub struct Video {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
  duration : Int
  thumbnail : PhotoSize?
  cover : Array[PhotoSize]?
  start_timestamp : Int?
  file_name : String?
  mime_type : String?
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn Video::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
  duration~ : Int,
  thumbnail? : PhotoSize,
  cover? : Array[PhotoSize],
  start_timestamp? : Int,
  file_name? : String,
  mime_type? : String,
  file_size? : Int64,
) -> Video {
  {
    file_id,
    file_unique_id,
    width,
    height,
    duration,
    thumbnail,
    cover,
    start_timestamp,
    file_name,
    mime_type,
    file_size,
  }
}

///|
pub impl @json.ToJson for Video with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
    "duration": @json.to_json(self.duration),
  }
  if self.thumbnail is Some(v) {
    obj["thumbnail"] = @json.to_json(v)
  }
  if self.cover is Some(v) {
    obj["cover"] = @json.to_json(v)
  }
  if self.start_timestamp is Some(v) {
    obj["start_timestamp"] = @json.to_json(v)
  }
  if self.file_name is Some(v) {
    obj["file_name"] = @json.to_json(v)
  }
  if self.mime_type is Some(v) {
    obj["mime_type"] = @json.to_json(v)
  }
  if self.file_size is Some(v) {
    obj["file_size"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for Video with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for Video")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let width : Int = @json.from_json(obj["width"], path~)
  let height : Int = @json.from_json(obj["height"], path~)
  let duration : Int = @json.from_json(obj["duration"], path~)
  let thumbnail : PhotoSize? = if obj.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let cover : Array[PhotoSize]? = if obj.get("cover") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let start_timestamp : Int? = if obj.get("start_timestamp") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_name : String? = if obj.get("file_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let mime_type : String? = if obj.get("mime_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if obj.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    file_id,
    file_unique_id,
    width,
    height,
    duration,
    thumbnail,
    cover,
    start_timestamp,
    file_name,
    mime_type,
    file_size,
  }
}
