///|
pub struct Document {
  file_id : String
  file_unique_id : String
  thumbnail : PhotoSize?
  file_name : String?
  mime_type : String?
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn Document::new(
  file_id~ : String,
  file_unique_id~ : String,
  thumbnail? : PhotoSize,
  file_name? : String,
  mime_type? : String,
  file_size? : Int64,
) -> Document {
  { file_id, file_unique_id, thumbnail, file_name, mime_type, file_size }
}

///|
pub impl @json.ToJson for Document with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
  }
  if self.thumbnail is Some(v) {
    obj["thumbnail"] = @json.to_json(v)
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
pub impl @json.FromJson for Document with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for Document")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let thumbnail : PhotoSize? = if obj.get("thumbnail") is Some(v) {
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
  { file_id, file_unique_id, thumbnail, file_name, mime_type, file_size }
}
