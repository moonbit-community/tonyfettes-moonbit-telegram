///|
pub struct Story {
  chat : Chat
  id : Int
} derive(Show, Eq)

///|
pub fn Story::new(chat~ : Chat, id~ : Int) -> Story {
  { chat, id }
}

///|
pub impl @json.ToJson for Story with to_json(self) {
  let object : Map[String, Json] = {
    "chat": @json.to_json(self.chat),
    "id": @json.to_json(self.id),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Story with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Story")
  }
  let chat : Chat = @json.from_json(object["chat"], path~)
  let id : Int = @json.from_json(object["id"], path~)
  { chat, id }
}
