///|
pub struct InlineQueryResultPhoto {
  type_ : String
  id : String
  photo_url : String
  thumbnail_url : String
  photo_width : Int?
  photo_height : Int?
  title : String?
  description : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultPhoto::new(
  id~ : String,
  photo_url~ : String,
  thumbnail_url~ : String,
  photo_width? : Int,
  photo_height? : Int,
  title? : String,
  description? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
) -> InlineQueryResultPhoto {
  {
    type_: "photo",
    id,
    photo_url,
    thumbnail_url,
    photo_width,
    photo_height,
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
pub impl @json.ToJson for InlineQueryResultPhoto with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "photo_url": @json.to_json(self.photo_url),
    "thumbnail_url": @json.to_json(self.thumbnail_url),
  }
  if self.photo_width is Some(v) {
    object["photo_width"] = @json.to_json(v)
  }
  if self.photo_height is Some(v) {
    object["photo_height"] = @json.to_json(v)
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
pub impl @json.FromJson for InlineQueryResultPhoto with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultPhoto",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let photo_url : String = @json.from_json(object["photo_url"], path~)
  let thumbnail_url : String = @json.from_json(object["thumbnail_url"], path~)
  let photo_width : Int? = if object.get("photo_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_height : Int? = if object.get("photo_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
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
  let input_message_content : InputTextMessageContent? = if object.get(
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
    photo_url,
    thumbnail_url,
    photo_width,
    photo_height,
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
pub struct InlineQueryResultGif {
  type_ : String
  id : String
  gif_url : String
  gif_width : Int?
  gif_height : Int?
  gif_duration : Int?
  thumbnail_url : String
  thumbnail_mime_type : String?
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultGif::new(
  id~ : String,
  gif_url~ : String,
  thumbnail_url~ : String,
  gif_width? : Int,
  gif_height? : Int,
  gif_duration? : Int,
  thumbnail_mime_type? : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
) -> InlineQueryResultGif {
  {
    type_: "gif",
    id,
    gif_url,
    gif_width,
    gif_height,
    gif_duration,
    thumbnail_url,
    thumbnail_mime_type,
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
pub impl @json.ToJson for InlineQueryResultGif with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "gif_url": @json.to_json(self.gif_url),
    "thumbnail_url": @json.to_json(self.thumbnail_url),
  }
  if self.gif_width is Some(v) {
    object["gif_width"] = @json.to_json(v)
  }
  if self.gif_height is Some(v) {
    object["gif_height"] = @json.to_json(v)
  }
  if self.gif_duration is Some(v) {
    object["gif_duration"] = @json.to_json(v)
  }
  if self.thumbnail_mime_type is Some(v) {
    object["thumbnail_mime_type"] = @json.to_json(v)
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
pub impl @json.FromJson for InlineQueryResultGif with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultGif",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let gif_url : String = @json.from_json(object["gif_url"], path~)
  let thumbnail_url : String = @json.from_json(object["thumbnail_url"], path~)
  let gif_width : Int? = if object.get("gif_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gif_height : Int? = if object.get("gif_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let gif_duration : Int? = if object.get("gif_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_mime_type : String? = if object.get("thumbnail_mime_type")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
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
  let input_message_content : InputTextMessageContent? = if object.get(
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
    gif_url,
    gif_width,
    gif_height,
    gif_duration,
    thumbnail_url,
    thumbnail_mime_type,
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
pub struct InlineQueryResultMpeg4Gif {
  type_ : String
  id : String
  mpeg4_url : String
  mpeg4_width : Int?
  mpeg4_height : Int?
  mpeg4_duration : Int?
  thumbnail_url : String
  thumbnail_mime_type : String?
  title : String?
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultMpeg4Gif::new(
  id~ : String,
  mpeg4_url~ : String,
  thumbnail_url~ : String,
  mpeg4_width? : Int,
  mpeg4_height? : Int,
  mpeg4_duration? : Int,
  thumbnail_mime_type? : String,
  title? : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
) -> InlineQueryResultMpeg4Gif {
  {
    type_: "mpeg4_gif",
    id,
    mpeg4_url,
    mpeg4_width,
    mpeg4_height,
    mpeg4_duration,
    thumbnail_url,
    thumbnail_mime_type,
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
pub impl @json.ToJson for InlineQueryResultMpeg4Gif with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "mpeg4_url": @json.to_json(self.mpeg4_url),
    "thumbnail_url": @json.to_json(self.thumbnail_url),
  }
  if self.mpeg4_width is Some(v) {
    object["mpeg4_width"] = @json.to_json(v)
  }
  if self.mpeg4_height is Some(v) {
    object["mpeg4_height"] = @json.to_json(v)
  }
  if self.mpeg4_duration is Some(v) {
    object["mpeg4_duration"] = @json.to_json(v)
  }
  if self.thumbnail_mime_type is Some(v) {
    object["thumbnail_mime_type"] = @json.to_json(v)
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
pub impl @json.FromJson for InlineQueryResultMpeg4Gif with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultMpeg4Gif",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let mpeg4_url : String = @json.from_json(object["mpeg4_url"], path~)
  let thumbnail_url : String = @json.from_json(object["thumbnail_url"], path~)
  let mpeg4_width : Int? = if object.get("mpeg4_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let mpeg4_height : Int? = if object.get("mpeg4_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let mpeg4_duration : Int? = if object.get("mpeg4_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_mime_type : String? = if object.get("thumbnail_mime_type")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
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
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
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
  let input_message_content : InputTextMessageContent? = if object.get(
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
    mpeg4_url,
    mpeg4_width,
    mpeg4_height,
    mpeg4_duration,
    thumbnail_url,
    thumbnail_mime_type,
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
pub struct InlineQueryResultVideo {
  type_ : String
  id : String
  video_url : String
  mime_type : String
  thumbnail_url : String
  title : String
  caption : String?
  parse_mode : String?
  caption_entities : Array[MessageEntity]?
  show_caption_above_media : Bool?
  video_width : Int?
  video_height : Int?
  video_duration : Int?
  description : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
} derive(Show, Eq)

///|
pub fn InlineQueryResultVideo::new(
  id~ : String,
  video_url~ : String,
  mime_type~ : String,
  thumbnail_url~ : String,
  title~ : String,
  caption? : String,
  parse_mode? : String,
  caption_entities? : Array[MessageEntity],
  show_caption_above_media? : Bool,
  video_width? : Int,
  video_height? : Int,
  video_duration? : Int,
  description? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
) -> InlineQueryResultVideo {
  {
    type_: "video",
    id,
    video_url,
    mime_type,
    thumbnail_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    video_width,
    video_height,
    video_duration,
    description,
    reply_markup,
    input_message_content,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultVideo with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "video_url": @json.to_json(self.video_url),
    "mime_type": @json.to_json(self.mime_type),
    "thumbnail_url": @json.to_json(self.thumbnail_url),
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
  if self.show_caption_above_media is Some(v) {
    object["show_caption_above_media"] = @json.to_json(v)
  }
  if self.video_width is Some(v) {
    object["video_width"] = @json.to_json(v)
  }
  if self.video_height is Some(v) {
    object["video_height"] = @json.to_json(v)
  }
  if self.video_duration is Some(v) {
    object["video_duration"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
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
pub impl @json.FromJson for InlineQueryResultVideo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultVideo",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let video_url : String = @json.from_json(object["video_url"], path~)
  let mime_type : String = @json.from_json(object["mime_type"], path~)
  let thumbnail_url : String = @json.from_json(object["thumbnail_url"], path~)
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
  let caption_entities : Array[MessageEntity]? = if object.get(
      "caption_entities",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_caption_above_media : Bool? = if object.get(
      "show_caption_above_media",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video_width : Int? = if object.get("video_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video_height : Int? = if object.get("video_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video_duration : Int? = if object.get("video_duration") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
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
  let input_message_content : InputTextMessageContent? = if object.get(
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
    video_url,
    mime_type,
    thumbnail_url,
    title,
    caption,
    parse_mode,
    caption_entities,
    show_caption_above_media,
    video_width,
    video_height,
    video_duration,
    description,
    reply_markup,
    input_message_content,
  }
}
