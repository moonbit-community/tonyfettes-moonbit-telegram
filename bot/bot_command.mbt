///|
pub struct BotCommand {
  command : String
  description : String
} derive(Show, Eq)

///|
pub fn BotCommand::new(command~ : String, description~ : String) -> BotCommand {
  { command, description }
}

pub impl @json.ToJson for BotCommand with to_json(self) {
  let obj : Map[String, Json] = {
    "command": @json.to_json(self.command),
    "description": @json.to_json(self.description),
  }
  @json.to_json(obj)
}

pub impl @json.FromJson for BotCommand with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for BotCommand")
  }
  let command : String = @json.from_json(obj["command"], path~)
  let description : String = @json.from_json(obj["description"], path~)
  { command, description }
}