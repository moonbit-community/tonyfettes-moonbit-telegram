///|
pub struct Dice {
  emoji : String
  value : Int
} derive(Show, Eq)

///|
pub fn Dice::new(emoji~ : String, value~ : Int) -> Dice {
  { emoji, value }
}

///|
pub impl @json.ToJson for Dice with to_json(self) {
  let object : Map[String, Json] = {
    "emoji": @json.to_json(self.emoji),
    "value": @json.to_json(self.value),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Dice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Dice")
  }
  let emoji : String = @json.from_json(object["emoji"], path~)
  let value : Int = @json.from_json(object["value"], path~)
  { emoji, value }
}
