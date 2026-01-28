///|
pub struct LinkPreviewOptions {
  is_disabled : Bool?
  url : String?
  prefer_small_media : Bool?
  prefer_large_media : Bool?
  show_above_text : Bool?
} derive(Show, Eq)

///|
pub fn LinkPreviewOptions::new(
  is_disabled? : Bool,
  url? : String,
  prefer_small_media? : Bool,
  prefer_large_media? : Bool,
  show_above_text? : Bool,
) -> LinkPreviewOptions {
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub impl @json.ToJson for LinkPreviewOptions with to_json(self) {
  let object : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    object["is_disabled"] = @json.to_json(v)
  }
  if self.url is Some(v) {
    object["url"] = @json.to_json(v)
  }
  if self.prefer_small_media is Some(v) {
    object["prefer_small_media"] = @json.to_json(v)
  }
  if self.prefer_large_media is Some(v) {
    object["prefer_large_media"] = @json.to_json(v)
  }
  if self.show_above_text is Some(v) {
    object["show_above_text"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for LinkPreviewOptions with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for LinkPreviewOptions")
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if object.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_small_media : Bool? = if object.get("prefer_small_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_large_media : Bool? = if object.get("prefer_large_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_above_text : Bool? = if object.get("show_above_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub struct TextQuote {
  text : String
  entities : Array[MessageEntity]?
  position : Int
  is_manual : Bool?
} derive(Show, Eq)

///|
pub fn TextQuote::new(
  text~ : String,
  entities? : Array[MessageEntity],
  position~ : Int,
  is_manual? : Bool,
) -> TextQuote {
  { text, entities, position, is_manual }
}

///|
pub impl @json.ToJson for TextQuote with to_json(self) {
  let object : Map[String, Json] = {
    "text": @json.to_json(self.text),
    "position": @json.to_json(self.position),
  }
  if self.entities is Some(v) {
    object["entities"] = @json.to_json(v)
  }
  if self.is_manual is Some(v) {
    object["is_manual"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for TextQuote with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for TextQuote")
  }
  let text : String = @json.from_json(object["text"], path~)
  let entities : Array[MessageEntity]? = if object.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let position : Int = @json.from_json(object["position"], path~)
  let is_manual : Bool? = if object.get("is_manual") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, entities, position, is_manual }
}
