///|
/// ChatId can be either an integer ID or a string username
pub(all) enum ChatId {
  Id(Int64)
  Username(String)
} derive(Show, Eq)

///|
pub impl @json.ToJson for ChatId with to_json(self) {
  match self {
    Id(id) => @json.to_json(id)
    Username(username) => @json.to_json(username)
  }
}

///|
pub impl @json.FromJson for ChatId with from_json(json, path) {
  match json {
    Number(n, ..) => Id(n.to_int64())
    String(s) => Username(s)
    _ =>
      raise @json.JsonDecodeError(path~, "Expected number or string for ChatId")
  }
}

///|
pub struct ReplyParameters {
  message_id : Int
  chat_id : ChatId?
  allow_sending_without_reply : Bool?
  quote : String?
  quote_parse_mode : String?
  quote_entities : Array[MessageEntity]?
  quote_position : Int?
} derive(Show, Eq)

///|
pub fn ReplyParameters::new(
  message_id~ : Int,
  chat_id? : ChatId,
  allow_sending_without_reply? : Bool,
  quote? : String,
  quote_parse_mode? : String,
  quote_entities? : Array[MessageEntity],
  quote_position? : Int,
) -> ReplyParameters {
  {
    message_id,
    chat_id,
    allow_sending_without_reply,
    quote,
    quote_parse_mode,
    quote_entities,
    quote_position,
  }
}

///|
pub impl @json.ToJson for ReplyParameters with to_json(self) {
  let object : Map[String, Json] = { "message_id": @json.to_json(self.message_id) }
  if self.chat_id is Some(v) {
    object["chat_id"] = @json.to_json(v)
  }
  if self.allow_sending_without_reply is Some(v) {
    object["allow_sending_without_reply"] = @json.to_json(v)
  }
  if self.quote is Some(v) {
    object["quote"] = @json.to_json(v)
  }
  if self.quote_parse_mode is Some(v) {
    object["quote_parse_mode"] = @json.to_json(v)
  }
  if self.quote_entities is Some(v) {
    object["quote_entities"] = @json.to_json(v)
  }
  if self.quote_position is Some(v) {
    object["quote_position"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ReplyParameters with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ReplyParameters")
  }
  let message_id : Int = @json.from_json(object["message_id"], path~)
  let chat_id : ChatId? = if object.get("chat_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allow_sending_without_reply : Bool? = if object.get(
      "allow_sending_without_reply",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote : String? = if object.get("quote") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_parse_mode : String? = if object.get("quote_parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_entities : Array[MessageEntity]? = if object.get("quote_entities")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let quote_position : Int? = if object.get("quote_position") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    message_id,
    chat_id,
    allow_sending_without_reply,
    quote,
    quote_parse_mode,
    quote_entities,
    quote_position,
  }
}

///|
/// Placeholder for MessageOrigin in ExternalReplyInfo context
pub struct MessageOriginPlaceholder {
  type_ : String
  date : Int
} derive(Show, Eq)

///|
pub fn MessageOriginPlaceholder::new(
  type_~ : String,
  date~ : Int,
) -> MessageOriginPlaceholder {
  { type_, date }
}

///|
pub impl @json.ToJson for MessageOriginPlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "date": @json.to_json(self.date),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for MessageOriginPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for MessageOriginPlaceholder",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let date : Int = @json.from_json(object["date"], path~)
  { type_, date }
}

///|
/// Placeholder for LinkPreviewOptions
pub struct LinkPreviewPlaceholder {
  is_disabled : Bool?
} derive(Show, Eq)

///|
pub fn LinkPreviewPlaceholder::new(
  is_disabled? : Bool,
) -> LinkPreviewPlaceholder {
  { is_disabled, }
}

///|
pub impl @json.ToJson for LinkPreviewPlaceholder with to_json(self) {
  let object : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    object["is_disabled"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for LinkPreviewPlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for LinkPreviewPlaceholder",
    )
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, }
}

///|
/// Placeholder for Game type
pub struct GamePlaceholder {
  title : String
  description : String
} derive(Show, Eq)

///|
pub fn GamePlaceholder::new(
  title~ : String,
  description~ : String,
) -> GamePlaceholder {
  { title, description }
}

///|
pub impl @json.ToJson for GamePlaceholder with to_json(self) {
  let object : Map[String, Json] = {
    "title": @json.to_json(self.title),
    "description": @json.to_json(self.description),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for GamePlaceholder with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for GamePlaceholder")
  }
  let title : String = @json.from_json(object["title"], path~)
  let description : String = @json.from_json(object["description"], path~)
  { title, description }
}

///|
pub struct ExternalReplyInfo {
  origin : MessageOriginPlaceholder
  chat : Chat?
  message_id : Int?
  link_preview_options : LinkPreviewPlaceholder?
  animation : Animation?
  audio : Audio?
  document : Document?
  paid_media : PaidMediaInfo?
  photo : Array[PhotoSize]?
  sticker : Sticker?
  story : Story?
  video : Video?
  video_note : VideoNote?
  voice : Voice?
  has_media_spoiler : Bool?
  contact : Contact?
  dice : Dice?
  game : GamePlaceholder?
  giveaway : Giveaway?
  giveaway_winners : GiveawayWinners?
  invoice : Invoice?
  location : Location?
  poll : Poll?
  venue : Venue?
} derive(Show, Eq)

///|
pub fn ExternalReplyInfo::new(
  origin~ : MessageOriginPlaceholder,
  chat? : Chat,
  message_id? : Int,
  link_preview_options? : LinkPreviewPlaceholder,
  animation? : Animation,
  audio? : Audio,
  document? : Document,
  paid_media? : PaidMediaInfo,
  photo? : Array[PhotoSize],
  sticker? : Sticker,
  story? : Story,
  video? : Video,
  video_note? : VideoNote,
  voice? : Voice,
  has_media_spoiler? : Bool,
  contact? : Contact,
  dice? : Dice,
  game? : GamePlaceholder,
  giveaway? : Giveaway,
  giveaway_winners? : GiveawayWinners,
  invoice? : Invoice,
  location? : Location,
  poll? : Poll,
  venue? : Venue,
) -> ExternalReplyInfo {
  {
    origin,
    chat,
    message_id,
    link_preview_options,
    animation,
    audio,
    document,
    paid_media,
    photo,
    sticker,
    story,
    video,
    video_note,
    voice,
    has_media_spoiler,
    contact,
    dice,
    game,
    giveaway,
    giveaway_winners,
    invoice,
    location,
    poll,
    venue,
  }
}

///|
pub impl @json.ToJson for ExternalReplyInfo with to_json(self) {
  let object : Map[String, Json] = { "origin": @json.to_json(self.origin) }
  if self.chat is Some(v) {
    object["chat"] = @json.to_json(v)
  }
  if self.message_id is Some(v) {
    object["message_id"] = @json.to_json(v)
  }
  if self.link_preview_options is Some(v) {
    object["link_preview_options"] = @json.to_json(v)
  }
  if self.animation is Some(v) {
    object["animation"] = @json.to_json(v)
  }
  if self.audio is Some(v) {
    object["audio"] = @json.to_json(v)
  }
  if self.document is Some(v) {
    object["document"] = @json.to_json(v)
  }
  if self.paid_media is Some(v) {
    object["paid_media"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    object["photo"] = @json.to_json(v)
  }
  if self.sticker is Some(v) {
    object["sticker"] = @json.to_json(v)
  }
  if self.story is Some(v) {
    object["story"] = @json.to_json(v)
  }
  if self.video is Some(v) {
    object["video"] = @json.to_json(v)
  }
  if self.video_note is Some(v) {
    object["video_note"] = @json.to_json(v)
  }
  if self.voice is Some(v) {
    object["voice"] = @json.to_json(v)
  }
  if self.has_media_spoiler is Some(v) {
    object["has_media_spoiler"] = @json.to_json(v)
  }
  if self.contact is Some(v) {
    object["contact"] = @json.to_json(v)
  }
  if self.dice is Some(v) {
    object["dice"] = @json.to_json(v)
  }
  if self.game is Some(v) {
    object["game"] = @json.to_json(v)
  }
  if self.giveaway is Some(v) {
    object["giveaway"] = @json.to_json(v)
  }
  if self.giveaway_winners is Some(v) {
    object["giveaway_winners"] = @json.to_json(v)
  }
  if self.invoice is Some(v) {
    object["invoice"] = @json.to_json(v)
  }
  if self.location is Some(v) {
    object["location"] = @json.to_json(v)
  }
  if self.poll is Some(v) {
    object["poll"] = @json.to_json(v)
  }
  if self.venue is Some(v) {
    object["venue"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ExternalReplyInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ExternalReplyInfo")
  }
  let origin : MessageOriginPlaceholder = @json.from_json(object["origin"], path~)
  let chat : Chat? = if object.get("chat") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message_id : Int? = if object.get("message_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewPlaceholder? = if object.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let animation : Animation? = if object.get("animation") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let audio : Audio? = if object.get("audio") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let document : Document? = if object.get("document") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let paid_media : PaidMediaInfo? = if object.get("paid_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo : Array[PhotoSize]? = if object.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let sticker : Sticker? = if object.get("sticker") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let story : Story? = if object.get("story") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video : Video? = if object.get("video") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let video_note : VideoNote? = if object.get("video_note") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let voice : Voice? = if object.get("voice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_media_spoiler : Bool? = if object.get("has_media_spoiler") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let contact : Contact? = if object.get("contact") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let dice : Dice? = if object.get("dice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let game : GamePlaceholder? = if object.get("game") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let giveaway : Giveaway? = if object.get("giveaway") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let giveaway_winners : GiveawayWinners? = if object.get("giveaway_winners")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let invoice : Invoice? = if object.get("invoice") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let location : Location? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let poll : Poll? = if object.get("poll") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let venue : Venue? = if object.get("venue") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    origin,
    chat,
    message_id,
    link_preview_options,
    animation,
    audio,
    document,
    paid_media,
    photo,
    sticker,
    story,
    video,
    video_note,
    voice,
    has_media_spoiler,
    contact,
    dice,
    game,
    giveaway,
    giveaway_winners,
    invoice,
    location,
    poll,
    venue,
  }
}
