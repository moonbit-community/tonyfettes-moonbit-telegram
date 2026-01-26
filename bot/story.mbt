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
  let obj : Map[String, Json] = {
    "chat": @json.to_json(self.chat),
    "id": @json.to_json(self.id),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for Story with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for Story")
  }
  let chat : Chat = @json.from_json(obj["chat"], path~)
  let id : Int = @json.from_json(obj["id"], path~)
  { chat, id }
}
