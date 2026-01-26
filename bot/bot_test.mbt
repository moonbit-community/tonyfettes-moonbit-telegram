///|
test "Bot::new with default base_url" {
  let bot = Bot::new(token="test_token")
  inspect(bot.token, content="test_token")
  inspect(bot.base_url, content="https://api.telegram.org")
}

///|
test "Bot::new with custom base_url" {
  let bot = Bot::new(token="test_token", base_url="https://custom.api.org")
  inspect(bot.token, content="test_token")
  inspect(bot.base_url, content="https://custom.api.org")
}
