///|
/// Represents a birthdate
pub struct Birthdate {
  day : Int
  month : Int
  year : Int?
} derive(Show, Eq)

///|
pub fn Birthdate::new(day~ : Int, month~ : Int, year? : Int) -> Birthdate {
  { day, month, year }
}

///|
pub impl @json.ToJson for Birthdate with to_json(self) {
  let object : Map[String, Json] = {
    "day": @json.to_json(self.day),
    "month": @json.to_json(self.month),
  }
  if self.year is Some(v) {
    object["year"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Birthdate with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Birthdate")
  }
  let day : Int = @json.from_json(object["day"], path~)
  let month : Int = @json.from_json(object["month"], path~)
  let year : Int? = if object.get("year") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { day, month, year }
}

///|
/// Represents a location to which a chat is connected
pub struct ChatLocation {
  location : Location
  address : String
} derive(Show, Eq)

///|
pub fn ChatLocation::new(
  location~ : Location,
  address~ : String,
) -> ChatLocation {
  { location, address }
}

///|
pub impl @json.ToJson for ChatLocation with to_json(self) {
  let object : Map[String, Json] = {
    "location": @json.to_json(self.location),
    "address": @json.to_json(self.address),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChatLocation with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatLocation")
  }
  let location : Location = @json.from_json(object["location"], path~)
  let address : String = @json.from_json(object["address"], path~)
  { location, address }
}

///|
/// Represents a reaction based on an emoji
pub struct ReactionTypeEmoji {
  emoji : String
} derive(Show, Eq)

///|
pub fn ReactionTypeEmoji::new(emoji~ : String) -> ReactionTypeEmoji {
  { emoji, }
}

///|
pub impl @json.ToJson for ReactionTypeEmoji with to_json(self) {
  let object : Map[String, Json] = {
    "type": "emoji",
    "emoji": @json.to_json(self.emoji),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ReactionTypeEmoji with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ReactionTypeEmoji")
  }
  let emoji : String = @json.from_json(object["emoji"], path~)
  { emoji, }
}

///|
/// Represents a reaction based on a custom emoji
pub struct ReactionTypeCustomEmoji {
  custom_emoji_id : String
} derive(Show, Eq)

///|
pub fn ReactionTypeCustomEmoji::new(
  custom_emoji_id~ : String,
) -> ReactionTypeCustomEmoji {
  { custom_emoji_id, }
}

///|
pub impl @json.ToJson for ReactionTypeCustomEmoji with to_json(self) {
  let object : Map[String, Json] = {
    "type": "custom_emoji",
    "custom_emoji_id": @json.to_json(self.custom_emoji_id),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ReactionTypeCustomEmoji with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ReactionTypeCustomEmoji",
    )
  }
  let custom_emoji_id : String = @json.from_json(
    object["custom_emoji_id"],
    path~,
  )
  { custom_emoji_id, }
}

///|
/// Represents a reaction type
pub(all) enum ReactionType {
  Emoji(ReactionTypeEmoji)
  CustomEmoji(ReactionTypeCustomEmoji)
} derive(Show, Eq)

///|
pub impl @json.ToJson for ReactionType with to_json(self) {
  match self {
    Emoji(v) => @json.to_json(v)
    CustomEmoji(v) => @json.to_json(v)
  }
}

///|
pub impl @json.FromJson for ReactionType with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ReactionType")
  }
  guard object["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field in ReactionType")
  }
  match type_ {
    "emoji" => Emoji(@json.from_json(json, path~))
    "custom_emoji" => CustomEmoji(@json.from_json(json, path~))
    _ => raise @json.JsonDecodeError(path~, "Unknown ReactionType: \{type_}")
  }
}

///|
/// Contains full information about a chat
pub struct ChatFullInfo {
  id : Int64
  type_ : String
  accent_color_id : Int
  max_reaction_count : Int
  title : String?
  username : String?
  first_name : String?
  last_name : String?
  is_forum : Bool?
  photo : ChatPhoto?
  active_usernames : Array[String]?
  birthdate : Birthdate?
  business_intro : BusinessIntro?
  business_location : BusinessLocation?
  business_opening_hours : BusinessOpeningHours?
  personal_chat : Chat?
  available_reactions : Array[ReactionType]?
  background_custom_emoji_id : String?
  profile_accent_color_id : Int?
  profile_background_custom_emoji_id : String?
  emoji_status_custom_emoji_id : String?
  emoji_status_expiration_date : Int?
  bio : String?
  has_private_forwards : Bool?
  has_restricted_voice_and_video_messages : Bool?
  join_to_send_messages : Bool?
  join_by_request : Bool?
  description : String?
  invite_link : String?
  pinned_message : Message?
  permissions : ChatPermissions?
  can_send_paid_media : Bool?
  slow_mode_delay : Int?
  unrestrict_boost_count : Int?
  message_auto_delete_time : Int?
  has_aggressive_anti_spam_enabled : Bool?
  has_hidden_members : Bool?
  has_protected_content : Bool?
  has_visible_history : Bool?
  sticker_set_name : String?
  can_set_sticker_set : Bool?
  custom_emoji_sticker_set_name : String?
  linked_chat_id : Int64?
  location : ChatLocation?
} derive(Show, Eq)

///|
pub fn ChatFullInfo::new(
  id~ : Int64,
  type_~ : String,
  accent_color_id~ : Int,
  max_reaction_count~ : Int,
  title? : String,
  username? : String,
  first_name? : String,
  last_name? : String,
  is_forum? : Bool,
  photo? : ChatPhoto,
  active_usernames? : Array[String],
  birthdate? : Birthdate,
  business_intro? : BusinessIntro,
  business_location? : BusinessLocation,
  business_opening_hours? : BusinessOpeningHours,
  personal_chat? : Chat,
  available_reactions? : Array[ReactionType],
  background_custom_emoji_id? : String,
  profile_accent_color_id? : Int,
  profile_background_custom_emoji_id? : String,
  emoji_status_custom_emoji_id? : String,
  emoji_status_expiration_date? : Int,
  bio? : String,
  has_private_forwards? : Bool,
  has_restricted_voice_and_video_messages? : Bool,
  join_to_send_messages? : Bool,
  join_by_request? : Bool,
  description? : String,
  invite_link? : String,
  pinned_message? : Message,
  permissions? : ChatPermissions,
  can_send_paid_media? : Bool,
  slow_mode_delay? : Int,
  unrestrict_boost_count? : Int,
  message_auto_delete_time? : Int,
  has_aggressive_anti_spam_enabled? : Bool,
  has_hidden_members? : Bool,
  has_protected_content? : Bool,
  has_visible_history? : Bool,
  sticker_set_name? : String,
  can_set_sticker_set? : Bool,
  custom_emoji_sticker_set_name? : String,
  linked_chat_id? : Int64,
  location? : ChatLocation,
) -> ChatFullInfo {
  {
    id,
    type_,
    accent_color_id,
    max_reaction_count,
    title,
    username,
    first_name,
    last_name,
    is_forum,
    photo,
    active_usernames,
    birthdate,
    business_intro,
    business_location,
    business_opening_hours,
    personal_chat,
    available_reactions,
    background_custom_emoji_id,
    profile_accent_color_id,
    profile_background_custom_emoji_id,
    emoji_status_custom_emoji_id,
    emoji_status_expiration_date,
    bio,
    has_private_forwards,
    has_restricted_voice_and_video_messages,
    join_to_send_messages,
    join_by_request,
    description,
    invite_link,
    pinned_message,
    permissions,
    can_send_paid_media,
    slow_mode_delay,
    unrestrict_boost_count,
    message_auto_delete_time,
    has_aggressive_anti_spam_enabled,
    has_hidden_members,
    has_protected_content,
    has_visible_history,
    sticker_set_name,
    can_set_sticker_set,
    custom_emoji_sticker_set_name,
    linked_chat_id,
    location,
  }
}

///|
pub impl @json.ToJson for ChatFullInfo with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "type": @json.to_json(self.type_),
    "accent_color_id": @json.to_json(self.accent_color_id),
    "max_reaction_count": @json.to_json(self.max_reaction_count),
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    object["username"] = @json.to_json(v)
  }
  if self.first_name is Some(v) {
    object["first_name"] = @json.to_json(v)
  }
  if self.last_name is Some(v) {
    object["last_name"] = @json.to_json(v)
  }
  if self.is_forum is Some(v) {
    object["is_forum"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    object["photo"] = @json.to_json(v)
  }
  if self.active_usernames is Some(v) {
    object["active_usernames"] = @json.to_json(v)
  }
  if self.birthdate is Some(v) {
    object["birthdate"] = @json.to_json(v)
  }
  if self.business_intro is Some(v) {
    object["business_intro"] = @json.to_json(v)
  }
  if self.business_location is Some(v) {
    object["business_location"] = @json.to_json(v)
  }
  if self.business_opening_hours is Some(v) {
    object["business_opening_hours"] = @json.to_json(v)
  }
  if self.personal_chat is Some(v) {
    object["personal_chat"] = @json.to_json(v)
  }
  if self.available_reactions is Some(v) {
    object["available_reactions"] = @json.to_json(v)
  }
  if self.background_custom_emoji_id is Some(v) {
    object["background_custom_emoji_id"] = @json.to_json(v)
  }
  if self.profile_accent_color_id is Some(v) {
    object["profile_accent_color_id"] = @json.to_json(v)
  }
  if self.profile_background_custom_emoji_id is Some(v) {
    object["profile_background_custom_emoji_id"] = @json.to_json(v)
  }
  if self.emoji_status_custom_emoji_id is Some(v) {
    object["emoji_status_custom_emoji_id"] = @json.to_json(v)
  }
  if self.emoji_status_expiration_date is Some(v) {
    object["emoji_status_expiration_date"] = @json.to_json(v)
  }
  if self.bio is Some(v) {
    object["bio"] = @json.to_json(v)
  }
  if self.has_private_forwards is Some(v) {
    object["has_private_forwards"] = @json.to_json(v)
  }
  if self.has_restricted_voice_and_video_messages is Some(v) {
    object["has_restricted_voice_and_video_messages"] = @json.to_json(v)
  }
  if self.join_to_send_messages is Some(v) {
    object["join_to_send_messages"] = @json.to_json(v)
  }
  if self.join_by_request is Some(v) {
    object["join_by_request"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
  }
  if self.invite_link is Some(v) {
    object["invite_link"] = @json.to_json(v)
  }
  if self.pinned_message is Some(v) {
    object["pinned_message"] = @json.to_json(v)
  }
  if self.permissions is Some(v) {
    object["permissions"] = @json.to_json(v)
  }
  if self.can_send_paid_media is Some(v) {
    object["can_send_paid_media"] = @json.to_json(v)
  }
  if self.slow_mode_delay is Some(v) {
    object["slow_mode_delay"] = @json.to_json(v)
  }
  if self.unrestrict_boost_count is Some(v) {
    object["unrestrict_boost_count"] = @json.to_json(v)
  }
  if self.message_auto_delete_time is Some(v) {
    object["message_auto_delete_time"] = @json.to_json(v)
  }
  if self.has_aggressive_anti_spam_enabled is Some(v) {
    object["has_aggressive_anti_spam_enabled"] = @json.to_json(v)
  }
  if self.has_hidden_members is Some(v) {
    object["has_hidden_members"] = @json.to_json(v)
  }
  if self.has_protected_content is Some(v) {
    object["has_protected_content"] = @json.to_json(v)
  }
  if self.has_visible_history is Some(v) {
    object["has_visible_history"] = @json.to_json(v)
  }
  if self.sticker_set_name is Some(v) {
    object["sticker_set_name"] = @json.to_json(v)
  }
  if self.can_set_sticker_set is Some(v) {
    object["can_set_sticker_set"] = @json.to_json(v)
  }
  if self.custom_emoji_sticker_set_name is Some(v) {
    object["custom_emoji_sticker_set_name"] = @json.to_json(v)
  }
  if self.linked_chat_id is Some(v) {
    object["linked_chat_id"] = @json.to_json(v)
  }
  if self.location is Some(v) {
    object["location"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChatFullInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatFullInfo")
  }
  let id : Int64 = @json.from_json(object["id"], path~)
  let type_ : String = @json.from_json(object["type"], path~)
  let accent_color_id : Int = @json.from_json(object["accent_color_id"], path~)
  let max_reaction_count : Int = @json.from_json(
    object["max_reaction_count"],
    path~,
  )
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let username : String? = if object.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let first_name : String? = if object.get("first_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_forum : Bool? = if object.get("is_forum") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo : ChatPhoto? = if object.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let active_usernames : Array[String]? = if object.get("active_usernames")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let birthdate : Birthdate? = if object.get("birthdate") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let business_intro : BusinessIntro? = if object.get("business_intro")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let business_location : BusinessLocation? = if object.get("business_location")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let business_opening_hours : BusinessOpeningHours? = if object.get(
      "business_opening_hours",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let personal_chat : Chat? = if object.get("personal_chat") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let available_reactions : Array[ReactionType]? = if object.get(
      "available_reactions",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let background_custom_emoji_id : String? = if object.get(
      "background_custom_emoji_id",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let profile_accent_color_id : Int? = if object.get("profile_accent_color_id")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let profile_background_custom_emoji_id : String? = if object.get(
      "profile_background_custom_emoji_id",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let emoji_status_custom_emoji_id : String? = if object.get(
      "emoji_status_custom_emoji_id",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let emoji_status_expiration_date : Int? = if object.get(
      "emoji_status_expiration_date",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let bio : String? = if object.get("bio") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_private_forwards : Bool? = if object.get("has_private_forwards")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_restricted_voice_and_video_messages : Bool? = if object.get(
      "has_restricted_voice_and_video_messages",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let join_to_send_messages : Bool? = if object.get("join_to_send_messages")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let join_by_request : Bool? = if object.get("join_by_request") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let invite_link : String? = if object.get("invite_link") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let pinned_message : Message? = if object.get("pinned_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let permissions : ChatPermissions? = if object.get("permissions") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_paid_media : Bool? = if object.get("can_send_paid_media")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let slow_mode_delay : Int? = if object.get("slow_mode_delay") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let unrestrict_boost_count : Int? = if object.get("unrestrict_boost_count")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message_auto_delete_time : Int? = if object.get(
      "message_auto_delete_time",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_aggressive_anti_spam_enabled : Bool? = if object.get(
      "has_aggressive_anti_spam_enabled",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_hidden_members : Bool? = if object.get("has_hidden_members")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_protected_content : Bool? = if object.get("has_protected_content")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let has_visible_history : Bool? = if object.get("has_visible_history")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let sticker_set_name : String? = if object.get("sticker_set_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_set_sticker_set : Bool? = if object.get("can_set_sticker_set")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let custom_emoji_sticker_set_name : String? = if object.get(
      "custom_emoji_sticker_set_name",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let linked_chat_id : Int64? = if object.get("linked_chat_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let location : ChatLocation? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    id,
    type_,
    accent_color_id,
    max_reaction_count,
    title,
    username,
    first_name,
    last_name,
    is_forum,
    photo,
    active_usernames,
    birthdate,
    business_intro,
    business_location,
    business_opening_hours,
    personal_chat,
    available_reactions,
    background_custom_emoji_id,
    profile_accent_color_id,
    profile_background_custom_emoji_id,
    emoji_status_custom_emoji_id,
    emoji_status_expiration_date,
    bio,
    has_private_forwards,
    has_restricted_voice_and_video_messages,
    join_to_send_messages,
    join_by_request,
    description,
    invite_link,
    pinned_message,
    permissions,
    can_send_paid_media,
    slow_mode_delay,
    unrestrict_boost_count,
    message_auto_delete_time,
    has_aggressive_anti_spam_enabled,
    has_hidden_members,
    has_protected_content,
    has_visible_history,
    sticker_set_name,
    can_set_sticker_set,
    custom_emoji_sticker_set_name,
    linked_chat_id,
    location,
  }
}
