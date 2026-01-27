///|
pub struct InputMessageContentPlaceholder {
  message_text : String
} derive(Show, Eq)

///|
pub fn InputMessageContentPlaceholder::new(
  message_text~ : String,
) -> InputMessageContentPlaceholder {
  { message_text, }
}

///|
pub impl @json.ToJson for InputMessageContentPlaceholder with to_json(self) {
  let obj : Map[String, Json] = {
    "message_text": @json.to_json(self.message_text),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputMessageContentPlaceholder with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputMessageContentPlaceholder",
    )
  }
  let message_text : String = @json.from_json(obj["message_text"], path~)
  { message_text, }
}

///|
pub struct InlineQueryResultAudio {
  type_ : String
  id : String
  audio_url : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  performer : String?
  audio_duration : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
} derive(Show, Eq)

///|
pub fn InlineQueryResultAudio::new(
  id~ : String,
  audio_url~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  performer? : String,
  audio_duration? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
) -> InlineQueryResultAudio {
  {
    type_: "audio",
    id,
    audio_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    performer,
    audio_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultAudio with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "audio_url": @json.to_json(self.audio_url),
    "title": @json.to_json(self.title),
  }
  if self.caption is Some(v) {
    obj["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    obj["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    obj["caption_entities"] = @json.to_json(v)
  }
  if self.performer is Some(v) {
    obj["performer"] = @json.to_json(v)
  }
  if self.audio_duration is Some(v) {
    obj["audio_duration"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultAudio with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultAudio",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let audio_url : String = @json.from_json(obj["audio_url"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let caption : String? = if obj.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if obj.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if obj.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let performer : String? = if obj.get("performer") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let audio_duration : Int? = if obj.get("audio_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    audio_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    performer,
    audio_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultVoice {
  type_ : String
  id : String
  voice_url : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  voice_duration : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
} derive(Show, Eq)

///|
pub fn InlineQueryResultVoice::new(
  id~ : String,
  voice_url~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  voice_duration? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
) -> InlineQueryResultVoice {
  {
    type_: "voice",
    id,
    voice_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    voice_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultVoice with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "voice_url": @json.to_json(self.voice_url),
    "title": @json.to_json(self.title),
  }
  if self.caption is Some(v) {
    obj["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    obj["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    obj["caption_entities"] = @json.to_json(v)
  }
  if self.voice_duration is Some(v) {
    obj["voice_duration"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultVoice with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultVoice",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let voice_url : String = @json.from_json(obj["voice_url"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let caption : String? = if obj.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if obj.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if obj.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let voice_duration : Int? = if obj.get("voice_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    voice_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    voice_duration,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultDocument {
  type_ : String
  id : String
  title : String
  document_url : String
  mime_type : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  description : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputMessageContentPlaceholder?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultDocument::new(
  id~ : String,
  title~ : String,
  document_url~ : String,
  mime_type~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  description? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputMessageContentPlaceholder,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultDocument {
  {
    type_: "document",
    id,
    title,
    document_url,
    mime_type,
    caption,
    parse_mode,
    caption_entities,
    description,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultDocument with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "title": @json.to_json(self.title),
    "document_url": @json.to_json(self.document_url),
    "mime_type": @json.to_json(self.mime_type),
  }
  if self.caption is Some(v) {
    obj["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    obj["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    obj["caption_entities"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    obj["description"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    obj["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    obj["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    obj["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultDocument with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultDocument",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let document_url : String = @json.from_json(obj["document_url"], path~)
  let mime_type : String = @json.from_json(obj["mime_type"], path~)
  let caption : String? = if obj.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if obj.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if obj.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if obj.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputMessageContentPlaceholder? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if obj.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if obj.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if obj.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    title,
    document_url,
    mime_type,
    caption,
    parse_mode,
    caption_entities,
    description,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}
