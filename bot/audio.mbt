///|
pub struct Audio {
  file_id : String
  file_unique_id : String
  duration : Int
  performer : String?
  title : String?
  file_name : String?
  mime_type : String?
  file_size : Int64?
  thumbnail : PhotoSize?
} derive(Show, Eq)

///|
pub fn Audio::new(
  file_id~ : String,
  file_unique_id~ : String,
  duration~ : Int,
  performer? : String,
  title? : String,
  file_name? : String,
  mime_type? : String,
  file_size? : Int64,
  thumbnail? : PhotoSize,
) -> Audio {
  {
    file_id,
    file_unique_id,
    duration,
    performer,
    title,
    file_name,
    mime_type,
    file_size,
    thumbnail,
  }
}

///|
pub impl @json.ToJson for Audio with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "duration": @json.to_json(self.duration),
  }
  if self.performer is Some(v) {
    object["performer"] = @json.to_json(v)
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.file_name is Some(v) {
    object["file_name"] = @json.to_json(v)
  }
  if self.mime_type is Some(v) {
    object["mime_type"] = @json.to_json(v)
  }
  if self.file_size is Some(v) {
    object["file_size"] = @json.to_json(v)
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Audio with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Audio")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let duration : Int = @json.from_json(object["duration"], path~)
  let performer : String? = if object.get("performer") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_name : String? = if object.get("file_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let mime_type : String? = if object.get("mime_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let file_size : Int64? = if object.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    file_id,
    file_unique_id,
    duration,
    performer,
    title,
    file_name,
    mime_type,
    file_size,
    thumbnail,
  }
}
