///|
pub struct GiftInfo {
  gift : Gift
  from : User?
} derive(Debug, Eq)

///|
pub fn GiftInfo::new(gift~ : Gift, from? : User) -> GiftInfo {
  { gift, from }
}

///|
pub impl @json.ToJson for GiftInfo with to_json(self) {
  let object : Map[String, Json] = { "gift": @json.to_json(self.gift) }
  if self.from is Some(v) {
    object["from"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for GiftInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for GiftInfo")
  }
  let gift : Gift = @json.from_json(object["gift"], path~)
  let from : User? = if object.get("from") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { gift, from }
}
