///|
test "PollOption JSON round-trip" {
  let option = PollOption::new(text="Option A", voter_count=10)
  let json = @json.to_json(option)
  let parsed : PollOption = @json.from_json(json)
  inspect(parsed.text, content="Option A")
  inspect(parsed.voter_count, content="10")
  inspect(parsed.text_entities, content="None")
}

///|
test "PollOption with text_entities JSON round-trip" {
  let entities : Array[MessageEntity] = [
    MessageEntity::new(type_="bold", offset=0, length=6),
  ]
  let option = PollOption::new(
    text="Option B",
    text_entities=entities,
    voter_count=5,
  )
  let json = @json.to_json(option)
  let parsed : PollOption = @json.from_json(json)
  inspect(parsed.text, content="Option B")
  inspect(parsed.voter_count, content="5")
  guard parsed.text_entities is Some(ents) else {
    fail("Expected text_entities to be Some")
  }
  inspect(ents.length(), content="1")
  inspect(ents[0].type_, content="bold")
}

///|
test "InputPollOption JSON round-trip" {
  let option = InputPollOption::new(text="Input Option")
  let json = @json.to_json(option)
  let parsed : InputPollOption = @json.from_json(json)
  inspect(parsed.text, content="Input Option")
  inspect(parsed.text_parse_mode, content="None")
  inspect(parsed.text_entities, content="None")
}

///|
test "InputPollOption with all fields JSON round-trip" {
  let entities : Array[MessageEntity] = [
    MessageEntity::new(type_="italic", offset=0, length=5),
  ]
  let option = InputPollOption::new(
    text="Styled Option",
    text_parse_mode="HTML",
    text_entities=entities,
  )
  let json = @json.to_json(option)
  let parsed : InputPollOption = @json.from_json(json)
  inspect(parsed.text, content="Styled Option")
  inspect(parsed.text_parse_mode, content="Some(\"HTML\")")
  guard parsed.text_entities is Some(ents) else {
    fail("Expected text_entities to be Some")
  }
  inspect(ents.length(), content="1")
}

///|
test "Poll JSON round-trip (regular poll)" {
  let options : Array[PollOption] = [
    PollOption::new(text="Yes", voter_count=10),
    PollOption::new(text="No", voter_count=5),
  ]
  let poll = Poll::new(
    id="poll123",
    question="Do you like MoonBit?",
    options~,
    total_voter_count=15,
    is_closed=false,
    is_anonymous=true,
    type_="regular",
    allows_multiple_answers=false,
  )
  let json = @json.to_json(poll)
  let parsed : Poll = @json.from_json(json)
  inspect(parsed.id, content="poll123")
  inspect(parsed.question, content="Do you like MoonBit?")
  inspect(parsed.options.length(), content="2")
  inspect(parsed.total_voter_count, content="15")
  inspect(parsed.is_closed, content="false")
  inspect(parsed.is_anonymous, content="true")
  inspect(parsed.type_, content="regular")
  inspect(parsed.allows_multiple_answers, content="false")
  inspect(parsed.correct_option_id, content="None")
  inspect(parsed.explanation, content="None")
}

///|
test "Poll JSON round-trip (quiz poll with all fields)" {
  let options : Array[PollOption] = [
    PollOption::new(text="Paris", voter_count=20),
    PollOption::new(text="London", voter_count=5),
    PollOption::new(text="Berlin", voter_count=3),
  ]
  let explanation_entities : Array[MessageEntity] = [
    MessageEntity::new(type_="bold", offset=0, length=5),
  ]
  let poll = Poll::new(
    id="quiz456",
    question="What is the capital of France?",
    options~,
    total_voter_count=28,
    is_closed=false,
    is_anonymous=false,
    type_="quiz",
    allows_multiple_answers=false,
    correct_option_id=0,
    explanation="Paris is the capital of France.",
    explanation_entities~,
    open_period=300,
    close_date=1700000000,
  )
  let json = @json.to_json(poll)
  let parsed : Poll = @json.from_json(json)
  inspect(parsed.id, content="quiz456")
  inspect(parsed.type_, content="quiz")
  inspect(parsed.correct_option_id, content="Some(0)")
  inspect(
    parsed.explanation,
    content="Some(\"Paris is the capital of France.\")",
  )
  guard parsed.explanation_entities is Some(ents) else {
    fail("Expected explanation_entities to be Some")
  }
  inspect(ents.length(), content="1")
  inspect(parsed.open_period, content="Some(300)")
  inspect(parsed.close_date, content="Some(1700000000)")
}

///|
test "Poll type field serializes as 'type'" {
  let options : Array[PollOption] = [PollOption::new(text="A", voter_count=0)]
  let poll = Poll::new(
    id="test",
    question="Test?",
    options~,
    total_voter_count=0,
    is_closed=false,
    is_anonymous=true,
    type_="quiz",
    allows_multiple_answers=false,
  )
  let json = @json.to_json(poll)
  guard json is Object(obj) else { fail("Expected object") }
  guard obj.get("type") is Some(String(type_val)) else {
    fail("Expected 'type' field in JSON")
  }
  inspect(type_val, content="quiz")
  // Ensure type_ is not serialized
  inspect(obj.get("type_"), content="None")
}

///|
test "PollAnswer JSON round-trip (minimal)" {
  let answer = PollAnswer::new(poll_id="poll789", option_ids=[0, 1])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll789")
  inspect(parsed.option_ids, content="[0, 1]")
  inspect(parsed.voter_chat, content="None")
  inspect(parsed.user, content="None")
}

///|
test "PollAnswer JSON round-trip (with user)" {
  let user = User::new(
    id=12345L,
    is_bot=false,
    first_name="John",
    last_name="Doe",
  )
  let answer = PollAnswer::new(poll_id="poll999", user~, option_ids=[2])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll999")
  inspect(parsed.option_ids, content="[2]")
  guard parsed.user is Some(u) else { fail("Expected user to be Some") }
  inspect(u.id, content="12345")
  inspect(u.first_name, content="John")
}

///|
test "PollAnswer JSON round-trip (with voter_chat)" {
  let chat = Chat::new(
    id=67890L,
    type_=ChatType::Supergroup,
    title="Test Group",
  )
  let answer = PollAnswer::new(poll_id="poll000", voter_chat=chat, option_ids=[
    0,
  ])
  let json = @json.to_json(answer)
  let parsed : PollAnswer = @json.from_json(json)
  inspect(parsed.poll_id, content="poll000")
  guard parsed.voter_chat is Some(c) else {
    fail("Expected voter_chat to be Some")
  }
  inspect(c.id, content="67890")
  inspect(c.type_, content="Supergroup")
  inspect(c.title, content="Some(\"Test Group\")")
}
