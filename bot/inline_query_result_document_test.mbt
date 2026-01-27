///|
test "InputMessageContentPlaceholder JSON round-trip" {
  let content = InputMessageContentPlaceholder::new(
    message_text="Hello, world!",
  )
  let json = @json.to_json(content)
  let parsed : InputMessageContentPlaceholder = @json.from_json(json)
  inspect(parsed.message_text, content="Hello, world!")
}

///|
test "InlineQueryResultAudio JSON round-trip" {
  let result = InlineQueryResultAudio::new(
    id="audio_123",
    audio_url="https://example.com/audio.mp3",
    title="Test Audio",
    caption="This is a test audio",
    parse_mode="HTML",
    performer="Test Artist",
    audio_duration=180,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultAudio = @json.from_json(json)
  inspect(parsed.type_, content="audio")
  inspect(parsed.id, content="audio_123")
  inspect(parsed.audio_url, content="https://example.com/audio.mp3")
  inspect(parsed.title, content="Test Audio")
  inspect(parsed.caption, content="Some(\"This is a test audio\")")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.performer, content="Some(\"Test Artist\")")
  inspect(parsed.audio_duration, content="Some(180)")
}

///|
test "InlineQueryResultAudio JSON round-trip with all optional fields" {
  let entity = MessageEntity::new(type_="bold", offset=0, length=4)
  let keyboard = InlineKeyboardMarkup::new(inline_keyboard=[
    [InlineKeyboardButton::new(text="Button", callback_data="btn_1")],
  ])
  let input_content = InputMessageContentPlaceholder::new(
    message_text="Custom message",
  )
  let result = InlineQueryResultAudio::new(
    id="audio_456",
    audio_url="https://example.com/audio2.mp3",
    title="Full Audio",
    caption="Bold text",
    parse_mode="HTML",
    caption_entities=[entity],
    performer="Artist",
    audio_duration=240,
    reply_markup=keyboard,
    input_message_content=input_content,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultAudio = @json.from_json(json)
  inspect(parsed.type_, content="audio")
  inspect(parsed.id, content="audio_456")
  guard parsed.caption_entities is Some(entities) else {
    fail("Expected caption_entities")
  }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="bold")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard.length(), content="1")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="Custom message")
}

///|
test "InlineQueryResultAudio JSON round-trip without optionals" {
  let result = InlineQueryResultAudio::new(
    id="audio_789",
    audio_url="https://example.com/audio3.mp3",
    title="Minimal Audio",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultAudio = @json.from_json(json)
  inspect(parsed.type_, content="audio")
  inspect(parsed.id, content="audio_789")
  inspect(parsed.caption, content="None")
  inspect(parsed.parse_mode, content="None")
  inspect(parsed.caption_entities, content="None")
  inspect(parsed.performer, content="None")
  inspect(parsed.audio_duration, content="None")
  inspect(parsed.reply_markup, content="None")
  inspect(parsed.input_message_content, content="None")
}

///|
test "InlineQueryResultVoice JSON round-trip" {
  let result = InlineQueryResultVoice::new(
    id="voice_123",
    voice_url="https://example.com/voice.ogg",
    title="Test Voice",
    caption="This is a test voice message",
    parse_mode="Markdown",
    voice_duration=30,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultVoice = @json.from_json(json)
  inspect(parsed.type_, content="voice")
  inspect(parsed.id, content="voice_123")
  inspect(parsed.voice_url, content="https://example.com/voice.ogg")
  inspect(parsed.title, content="Test Voice")
  inspect(parsed.caption, content="Some(\"This is a test voice message\")")
  inspect(parsed.parse_mode, content="Some(\"Markdown\")")
  inspect(parsed.voice_duration, content="Some(30)")
}

///|
test "InlineQueryResultVoice JSON round-trip with all optional fields" {
  let entity = MessageEntity::new(type_="italic", offset=0, length=5)
  let keyboard = InlineKeyboardMarkup::new(inline_keyboard=[
    [InlineKeyboardButton::new(text="Play", callback_data="play")],
  ])
  let input_content = InputMessageContentPlaceholder::new(
    message_text="Voice message content",
  )
  let result = InlineQueryResultVoice::new(
    id="voice_456",
    voice_url="https://example.com/voice2.ogg",
    title="Full Voice",
    caption="Italic text",
    parse_mode="HTML",
    caption_entities=[entity],
    voice_duration=60,
    reply_markup=keyboard,
    input_message_content=input_content,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultVoice = @json.from_json(json)
  inspect(parsed.type_, content="voice")
  inspect(parsed.id, content="voice_456")
  guard parsed.caption_entities is Some(entities) else {
    fail("Expected caption_entities")
  }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="italic")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard.length(), content="1")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="Voice message content")
}

///|
test "InlineQueryResultVoice JSON round-trip without optionals" {
  let result = InlineQueryResultVoice::new(
    id="voice_789",
    voice_url="https://example.com/voice3.ogg",
    title="Minimal Voice",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultVoice = @json.from_json(json)
  inspect(parsed.type_, content="voice")
  inspect(parsed.id, content="voice_789")
  inspect(parsed.caption, content="None")
  inspect(parsed.parse_mode, content="None")
  inspect(parsed.caption_entities, content="None")
  inspect(parsed.voice_duration, content="None")
  inspect(parsed.reply_markup, content="None")
  inspect(parsed.input_message_content, content="None")
}

///|
test "InlineQueryResultDocument JSON round-trip" {
  let result = InlineQueryResultDocument::new(
    id="doc_123",
    title="Test Document",
    document_url="https://example.com/doc.pdf",
    mime_type="application/pdf",
    caption="This is a test document",
    parse_mode="HTML",
    description="A PDF document for testing",
    thumbnail_url="https://example.com/thumb.jpg",
    thumbnail_width=100,
    thumbnail_height=100,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultDocument = @json.from_json(json)
  inspect(parsed.type_, content="document")
  inspect(parsed.id, content="doc_123")
  inspect(parsed.title, content="Test Document")
  inspect(parsed.document_url, content="https://example.com/doc.pdf")
  inspect(parsed.mime_type, content="application/pdf")
  inspect(parsed.caption, content="Some(\"This is a test document\")")
  inspect(parsed.parse_mode, content="Some(\"HTML\")")
  inspect(parsed.description, content="Some(\"A PDF document for testing\")")
  inspect(
    parsed.thumbnail_url,
    content="Some(\"https://example.com/thumb.jpg\")",
  )
  inspect(parsed.thumbnail_width, content="Some(100)")
  inspect(parsed.thumbnail_height, content="Some(100)")
}

///|
test "InlineQueryResultDocument JSON round-trip with all optional fields" {
  let entity = MessageEntity::new(type_="code", offset=0, length=4)
  let keyboard = InlineKeyboardMarkup::new(inline_keyboard=[
    [
      InlineKeyboardButton::new(
        text="Download",
        url="https://example.com/doc.pdf",
      ),
    ],
  ])
  let input_content = InputMessageContentPlaceholder::new(
    message_text="Document content",
  )
  let result = InlineQueryResultDocument::new(
    id="doc_456",
    title="Full Document",
    document_url="https://example.com/doc2.pdf",
    mime_type="application/pdf",
    caption="Code text",
    parse_mode="HTML",
    caption_entities=[entity],
    description="Full document with all options",
    reply_markup=keyboard,
    input_message_content=input_content,
    thumbnail_url="https://example.com/thumb2.jpg",
    thumbnail_width=200,
    thumbnail_height=150,
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultDocument = @json.from_json(json)
  inspect(parsed.type_, content="document")
  inspect(parsed.id, content="doc_456")
  guard parsed.caption_entities is Some(entities) else {
    fail("Expected caption_entities")
  }
  inspect(entities.length(), content="1")
  inspect(entities[0].type_, content="code")
  guard parsed.reply_markup is Some(markup) else {
    fail("Expected reply_markup")
  }
  inspect(markup.inline_keyboard.length(), content="1")
  guard parsed.input_message_content is Some(content) else {
    fail("Expected input_message_content")
  }
  inspect(content.message_text, content="Document content")
  inspect(parsed.thumbnail_width, content="Some(200)")
  inspect(parsed.thumbnail_height, content="Some(150)")
}

///|
test "InlineQueryResultDocument JSON round-trip without optionals" {
  let result = InlineQueryResultDocument::new(
    id="doc_789",
    title="Minimal Document",
    document_url="https://example.com/doc3.pdf",
    mime_type="application/pdf",
  )
  let json = @json.to_json(result)
  let parsed : InlineQueryResultDocument = @json.from_json(json)
  inspect(parsed.type_, content="document")
  inspect(parsed.id, content="doc_789")
  inspect(parsed.caption, content="None")
  inspect(parsed.parse_mode, content="None")
  inspect(parsed.caption_entities, content="None")
  inspect(parsed.description, content="None")
  inspect(parsed.reply_markup, content="None")
  inspect(parsed.input_message_content, content="None")
  inspect(parsed.thumbnail_url, content="None")
  inspect(parsed.thumbnail_width, content="None")
  inspect(parsed.thumbnail_height, content="None")
}
