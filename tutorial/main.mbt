///|
async fn main {
  let token = @sys.get_env_var("BOT_TOKEN").unwrap()
  let bot = @bot.Bot::new(token~)
  let me = bot.get_me()
  println("Bot started: @\{me.username.unwrap()}")

  // Set bot commands (shown in Telegram's menu)
  bot.set_my_commands(commands=[
    @bot.BotCommand::new(command="scream", description="Make the bot SCREAM"),
    @bot.BotCommand::new(command="whisper", description="Make the bot whisper"),
    @bot.BotCommand::new(command="menu", description="Show menu"),
  ])
  |> ignore()

  // Bot state
  let screaming : Ref[Bool] = { val: false }
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~)
    for update in updates {
      offset = update.update_id + 1
      if update.message is Some(msg) {
        if msg.text is Some(text) {
          // Handle commands
          if text.has_prefix("/scream") {
            screaming.val = true
          } else if text.has_prefix("/whisper") {
            screaming.val = false
          } else if text.has_prefix("/") {
            // Ignore other commands
            continue
          } else {
            // Echo message (screaming or normal)
            let response = if screaming.val { text.to_upper() } else { text }
            bot.send_message(chat_id=msg.chat.id, text=response) |> ignore()
          }
        }
      }
    }
  }
}
