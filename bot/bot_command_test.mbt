///|
test "BotCommand JSON round-trip" {
  let cmd = BotCommand::new(command="start", description="Start the bot")
  let json = @json.to_json(cmd)
  let parsed : BotCommand = @json.from_json(json)
  inspect(parsed.command, content="start")
  inspect(parsed.description, content="Start the bot")
}
