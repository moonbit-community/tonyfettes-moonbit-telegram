# Telegram Bot Tutorial in MoonBit

This tutorial walks you through creating a Telegram bot using MoonBit and the `tonyfettes/telegram` library. It mirrors the [official Telegram Bot Tutorial](https://core.telegram.org/bots/tutorial).

## Prerequisites

1. Create a bot via [@BotFather](https://t.me/botfather) and obtain your bot token
2. Install the MoonBit toolchain

## Project Setup

Create a new MoonBit project:

```bash
moon new my_bot
cd my_bot
moon add tonyfettes/telegram
```

Update `moon.pkg.json` in your main package:

```json
{
  "is-main": true,
  "import": [
    "tonyfettes/telegram/bot",
    "moonbitlang/async",
    "moonbitlang/async/stdio"
  ]
}
```

## Step 1: Echo Bot

Start with a simple bot that echoes messages back to the user.

```moonbit
async fn main {
  guard @sys.get_env_var("BOT_TOKEN") is Some(token) else {
    fail("BOT_TOKEN environment variable is not set")
  }
  let bot = @bot.Bot::new(token~)

  // Verify the bot token
  let me = bot.get_me()
  println("Bot started: @\{me.username.unwrap()}")

  // Main loop
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~)
    for update in updates {
      offset = update.update_id + 1
      if update.message is Some(msg) {
        if msg.text is Some(text) {
          bot.send_message(chat_id=msg.chat.id, text~) |> ignore()
        }
      }
    }
  }
}
```

Run with:

```bash
BOT_TOKEN="your_token_here" moon run .
```

## Step 2: Adding Commands

Add `/scream` and `/whisper` commands to control how the bot responds.

```moonbit
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
```

## Step 3: Interactive Menu with Inline Keyboards

Add a `/menu` command with navigation buttons.

```moonbit
fn main {
  @async.run(
    async fn() {
      let token = @async.env("BOT_TOKEN").unwrap()
      let bot = @bot.Bot::new(token~)

      let me = bot.get_me()
      println("Bot started: @\{me.username.unwrap()}")

      bot.set_my_commands(commands=[
        @bot.BotCommand::new(command="scream", description="Make the bot SCREAM"),
        @bot.BotCommand::new(command="whisper", description="Make the bot whisper"),
        @bot.BotCommand::new(command="menu", description="Show menu"),
      ])

      // Define keyboards
      let keyboard_menu1 = @bot.InlineKeyboardMarkup::new(inline_keyboard=[
        [@bot.InlineKeyboardButton::new(text="Next", callback_data="next")],
      ])

      let keyboard_menu2 = @bot.InlineKeyboardMarkup::new(inline_keyboard=[
        [
          @bot.InlineKeyboardButton::new(text="Back", callback_data="back"),
          @bot.InlineKeyboardButton::new(
            text="Tutorial",
            url="https://core.telegram.org/bots/tutorial",
          ),
        ],
      ])

      let screaming : Ref[Bool] = { val: false }

      let mut offset = 0
      while true {
        let updates = bot.get_updates(offset?)
        for update in updates {
          offset = update.update_id + 1

          // Handle messages
          if update.message is Some(msg) {
            if msg.text is Some(text) {
              if text.starts_with("/scream") {
                screaming.val = true
              } else if text.starts_with("/whisper") {
                screaming.val = false
              } else if text.starts_with("/menu") {
                // Send menu
                bot.send_message(
                  chat_id=msg.chat.id,
                  text="<b>Menu 1</b>",
                  parse_mode="HTML",
                  reply_markup=keyboard_menu1,
                )
              } else if not(text.starts_with("/")) {
                let response = if screaming.val {
                  text.to_upper()
                } else {
                  text
                }
                bot.send_message(chat_id=msg.chat.id, text=response)
              }
            }
          }

          // Handle callback queries (button presses)
          if update.callback_query is Some(query) {
            // Answer the callback to remove loading state
            bot.answer_callback_query(callback_query_id=query.id)

            // Get the message to edit
            if query.message is Some(msg) {
              if query.data is Some(data) {
                match data {
                  "next" =>
                    bot.edit_message_text(
                      chat_id=msg.chat.id,
                      message_id=msg.message_id,
                      text="<b>Menu 2</b>",
                      parse_mode="HTML",
                      reply_markup=keyboard_menu2,
                    )
                  "back" =>
                    bot.edit_message_text(
                      chat_id=msg.chat.id,
                      message_id=msg.message_id,
                      text="<b>Menu 1</b>",
                      parse_mode="HTML",
                      reply_markup=keyboard_menu1,
                    )
                  _ => ()
                }
              }
            }
          }
        }
      }
    },
  )
}
```

## Step 4: Copying Messages

Use `copy_message` to forward messages without the "Forwarded from" header:

```moonbit
// Inside the message handler, to echo any message type:
if update.message is Some(msg) {
  bot.copy_message(
    chat_id=msg.chat.id,
    from_chat_id=msg.chat.id,
    message_id=msg.message_id,
  )
}
```

## API Reference

### Bot Methods

| Method | Description |
|--------|-------------|
| `Bot::new(token~)` | Create a new bot instance |
| `get_me()` | Test bot token, returns `User` |
| `send_message(chat_id~, text~, ...)` | Send a text message |
| `copy_message(chat_id~, from_chat_id~, message_id~)` | Copy a message |
| `edit_message_text(chat_id~, message_id~, text~, ...)` | Edit message text |
| `edit_message_reply_markup(chat_id~, message_id~, ...)` | Edit inline keyboard |
| `answer_callback_query(callback_query_id~, ...)` | Answer button press |
| `set_my_commands(commands~)` | Set bot command menu |
| `get_updates(offset?, ...)` | Long-poll for updates |

### Types

| Type | Description |
|------|-------------|
| `Update` | Incoming update (message, callback_query, etc.) |
| `Message` | A message with text, from, chat, etc. |
| `User` | A Telegram user |
| `Chat` | A chat (private, group, etc.) |
| `CallbackQuery` | Button press from inline keyboard |
| `InlineKeyboardMarkup` | Inline keyboard layout |
| `InlineKeyboardButton` | A button with text and callback_data or url |
| `BotCommand` | Command shown in bot menu |

## Error Handling

All bot methods raise `TelegramError`. Handle errors with try-catch:

```moonbit
try {
  bot.send_message(chat_id=chat_id, text="Hello")
} catch {
  @bot.TelegramError::ApiError(code~, description~) =>
    println("API error \{code}: \{description}")
  @bot.TelegramError::HttpError(code~, body~) =>
    println("HTTP error \{code}: \{body}")
  error =>
    println("Error: \{error}")
}
```
