///|
pub struct Animation {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
  duration : Int
  thumbnail : PhotoSize?
  file_name : String?
  mime_type : String?
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn Animation::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
  duration~ : Int,
  thumbnail? : PhotoSize,
  file_name? : String,
  mime_type? : String,
  file_size? : Int64,
) -> Animation {
  {
    file_id,
    file_unique_id,
    width,
    height,
    duration,
    thumbnail,
    file_name,
    mime_type,
    file_size,
  }
}

///|
pub impl @json.ToJson for Animation with to_json(self) {
  let object : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
    "duration": @json.to_json(self.duration),
  }
  if self.thumbnail is Some(v) {
    object["thumbnail"] = @json.to_json(v)
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
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Animation with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Animation")
  }
  let file_id : String = @json.from_json(object["file_id"], path~)
  let file_unique_id : String = @json.from_json(object["file_unique_id"], path~)
  let width : Int = @json.from_json(object["width"], path~)
  let height : Int = @json.from_json(object["height"], path~)
  let duration : Int = @json.from_json(object["duration"], path~)
  let thumbnail : PhotoSize? = if object.get("thumbnail") is Some(v) {
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
  {
    file_id,
    file_unique_id,
    width,
    height,
    duration,
    thumbnail,
    file_name,
    mime_type,
    file_size,
  }
}
