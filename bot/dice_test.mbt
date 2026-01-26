///|
test "Dice JSON round-trip" {
  let dice = Dice::new(emoji="🎲", value=6)
  let json = @json.to_json(dice)
  let parsed : Dice = @json.from_json(json)
  inspect(parsed.emoji, content="🎲")
  inspect(parsed.value, content="6")
}

///|
test "Dice different emojis" {
  let dart = Dice::new(emoji="🎯", value=5)
  let basketball = Dice::new(emoji="🏀", value=4)
  inspect(dart.emoji, content="🎯")
  inspect(basketball.value, content="4")
}
