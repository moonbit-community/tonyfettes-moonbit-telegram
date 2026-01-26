///|
pub struct BotCommand {
  command : String
  description : String
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn BotCommand::new(command~ : String, description~ : String) -> BotCommand {
  { command, description }
}
