///|
pub struct PhotoSize {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
  file_size : Int64?
} derive(Show, Eq)

///|
pub fn PhotoSize::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
  file_size? : Int64,
) -> PhotoSize {
  { file_id, file_unique_id, width, height, file_size }
}

///|
pub impl @json.ToJson for PhotoSize with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
  }
  if self.file_size is Some(v) {
    obj["file_size"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PhotoSize with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for PhotoSize")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let width : Int = @json.from_json(obj["width"], path~)
  let height : Int = @json.from_json(obj["height"], path~)
  let file_size : Int64? = if obj.get("file_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { file_id, file_unique_id, width, height, file_size }
}
