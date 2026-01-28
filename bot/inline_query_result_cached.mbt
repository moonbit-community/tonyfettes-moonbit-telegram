///|
pub struct CachedInputMessageContent {
  message_text : String
} derive(Show, Eq)

///|
pub fn CachedInputMessageContent::new(
  message_text~ : String,
) -> CachedInputMessageContent {
  { message_text, }
}

///|
pub impl @json.ToJson for CachedInputMessageContent with to_json(self) {
  let object : Map[String, Json] = {
    "message_text": @json.to_json(self.message_text),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for CachedInputMessageContent with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for CachedInputMessageContent",
    )
  }
  let message_text : String = @json.from_json(object["message_text"], path~)
  { message_text, }
}

///|
pub struct InlineQueryResultCachedPhoto {
  type_ : String
  id : String
  photo_file_id : String
  title : String?
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedPhoto::new(
  id~ : String,
  photo_file_id~ : String,
  title? : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedPhoto {
  {
    type_: "photo",
    id,
    photo_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedPhoto with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "photo_file_id": @json.to_json(self.photo_file_id),
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedPhoto with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedPhoto",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let photo_file_id : String = @json.from_json(object["photo_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get("show_caption_above_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    photo_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedGif {
  type_ : String
  id : String
  gif_file_id : String
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedGif::new(
  id~ : String,
  gif_file_id~ : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedGif {
  {
    type_: "gif",
    id,
    gif_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedGif with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "gif_file_id": @json.to_json(self.gif_file_id),
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedGif with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedGif",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let gif_file_id : String = @json.from_json(object["gif_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get("show_caption_above_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    gif_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedMpeg4Gif {
  type_ : String
  id : String
  mpeg4_file_id : String
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedMpeg4Gif::new(
  id~ : String,
  mpeg4_file_id~ : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedMpeg4Gif {
  {
    type_: "mpeg4_gif",
    id,
    mpeg4_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedMpeg4Gif with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "mpeg4_file_id": @json.to_json(self.mpeg4_file_id),
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedMpeg4Gif with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedMpeg4Gif",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let mpeg4_file_id : String = @json.from_json(object["mpeg4_file_id"], path~)
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get("show_caption_above_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    mpeg4_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedSticker {
  type_ : String
  id : String
  sticker_file_id : String
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedSticker::new(
  id~ : String,
  sticker_file_id~ : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedSticker {
  { type_: "sticker", id, sticker_file_id, reply_markup, input_message_content }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedSticker with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "sticker_file_id": @json.to_json(self.sticker_file_id),
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedSticker with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedSticker",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let sticker_file_id : String = @json.from_json(object["sticker_file_id"], path~)
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { type_, id, sticker_file_id, reply_markup, input_message_content }
}

///|
pub struct InlineQueryResultCachedDocument {
  type_ : String
  id : String
  title : String
  document_file_id : String
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedDocument::new(
  id~ : String,
  title~ : String,
  document_file_id~ : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedDocument {
  {
    type_: "document",
    id,
    title,
    document_file_id,
    description,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedDocument with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "title": @json.to_json(self.title),
    "document_file_id": @json.to_json(self.document_file_id),
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedDocument with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedDocument",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let document_file_id : String = @json.from_json(
    object["document_file_id"],
    path~,
  )
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    title,
    document_file_id,
    description,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedVideo {
  type_ : String
  id : String
  video_file_id : String
  title : String
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedVideo::new(
  id~ : String,
  video_file_id~ : String,
  title~ : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedVideo {
  {
    type_: "video",
    id,
    video_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedVideo with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "video_file_id": @json.to_json(self.video_file_id),
    "title": @json.to_json(self.title),
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedVideo with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedVideo",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let video_file_id : String = @json.from_json(object["video_file_id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get("show_caption_above_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    video_file_id,
    title,
    description,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedVoice {
  type_ : String
  id : String
  voice_file_id : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedVoice::new(
  id~ : String,
  voice_file_id~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedVoice {
  {
    type_: "voice",
    id,
    voice_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedVoice with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "voice_file_id": @json.to_json(self.voice_file_id),
    "title": @json.to_json(self.title),
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedVoice with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedVoice",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let voice_file_id : String = @json.from_json(object["voice_file_id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    voice_file_id,
    title,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub struct InlineQueryResultCachedAudio {
  type_ : String
  id : String
  audio_file_id : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : CachedInputMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultCachedAudio::new(
  id~ : String,
  audio_file_id~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : CachedInputMessageContent,
) -> InlineQueryResultCachedAudio {
  {
    type_: "audio",
    id,
    audio_file_id,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultCachedAudio with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "audio_file_id": @json.to_json(self.audio_file_id),
  }
  if self.caption is Some(v) {
    object["caption"] = @json.to_json(v)
  }
  if self.parse_mode is Some(v) {
    object["parse_mode"] = @json.to_json(v)
  }
  if self.caption_entities is Some(v) {
    object["caption_entities"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultCachedAudio with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultCachedAudio",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let audio_file_id : String = @json.from_json(object["audio_file_id"], path~)
  let caption : String? = if object.get("caption") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let parse_mode : String? = if object.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let caption_entities : Array[MessageEntity]? = if object.get("caption_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : CachedInputMessageContent? = if object.get(
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
    audio_file_id,
    caption,
    parse_mode,
    caption_entities,
    reply_markup,
    input_message_content,
  }
}
