///|
pub struct DirectMessagesTopic {
  id : Int
  name : String
  icon_color : Int
} derive(Debug, Eq)

///|
pub fn DirectMessagesTopic::new(
  id~ : Int,
  name~ : String,
  icon_color~ : Int,
) -> DirectMessagesTopic {
  { id, name, icon_color }
}

///|
pub impl @json.ToJson for DirectMessagesTopic with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "name": @json.to_json(self.name),
    "icon_color": @json.to_json(self.icon_color),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for DirectMessagesTopic with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for DirectMessagesTopic",
    )
  }
  let id : Int = @json.from_json(object["id"], path~)
  let name : String = @json.from_json(object["name"], path~)
  let icon_color : Int = @json.from_json(object["icon_color"], path~)
  { id, name, icon_color }
}
