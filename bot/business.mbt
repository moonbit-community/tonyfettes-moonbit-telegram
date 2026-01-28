///|
/// Describes an interval of time during which a business is open.
pub struct BusinessOpeningHoursInterval {
  opening_minute : Int
  closing_minute : Int
} derive(Show, Eq)

///|
pub fn BusinessOpeningHoursInterval::new(
  opening_minute~ : Int,
  closing_minute~ : Int,
) -> BusinessOpeningHoursInterval {
  { opening_minute, closing_minute }
}

///|
pub impl @json.ToJson for BusinessOpeningHoursInterval with to_json(self) {
  let object : Map[String, Json] = {
    "opening_minute": @json.to_json(self.opening_minute),
    "closing_minute": @json.to_json(self.closing_minute),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessOpeningHoursInterval with from_json(
  json,
  path,
) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for BusinessOpeningHoursInterval",
    )
  }
  let opening_minute : Int = @json.from_json(object["opening_minute"], path~)
  let closing_minute : Int = @json.from_json(object["closing_minute"], path~)
  { opening_minute, closing_minute }
}

///|
/// Contains information about the opening hours of a business.
pub struct BusinessOpeningHours {
  time_zone_name : String
  opening_hours : Array[BusinessOpeningHoursInterval]
} derive(Show, Eq)

///|
pub fn BusinessOpeningHours::new(
  time_zone_name~ : String,
  opening_hours~ : Array[BusinessOpeningHoursInterval],
) -> BusinessOpeningHours {
  { time_zone_name, opening_hours }
}

///|
pub impl @json.ToJson for BusinessOpeningHours with to_json(self) {
  let object : Map[String, Json] = {
    "time_zone_name": @json.to_json(self.time_zone_name),
    "opening_hours": @json.to_json(self.opening_hours),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessOpeningHours with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for BusinessOpeningHours",
    )
  }
  let time_zone_name : String = @json.from_json(object["time_zone_name"], path~)
  let opening_hours : Array[BusinessOpeningHoursInterval] = @json.from_json(
    object["opening_hours"],
    path~,
  )
  { time_zone_name, opening_hours }
}

///|
/// Contains information about the location of a business.
pub struct BusinessLocation {
  address : String
  location : Location?
} derive(Show, Eq)

///|
pub fn BusinessLocation::new(
  address~ : String,
  location? : Location,
) -> BusinessLocation {
  { address, location }
}

///|
pub impl @json.ToJson for BusinessLocation with to_json(self) {
  let object : Map[String, Json] = { "address": @json.to_json(self.address) }
  if self.location is Some(v) {
    object["location"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessLocation with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for BusinessLocation")
  }
  let address : String = @json.from_json(object["address"], path~)
  let location : Location? = if object.get("location") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { address, location }
}

///|
/// Contains information about the intro of a business account.
pub struct BusinessIntro {
  title : String?
  message : String?
  sticker : Sticker?
} derive(Show, Eq)

///|
pub fn BusinessIntro::new(
  title? : String,
  message? : String,
  sticker? : Sticker,
) -> BusinessIntro {
  { title, message, sticker }
}

///|
pub impl @json.ToJson for BusinessIntro with to_json(self) {
  let object : Map[String, Json] = {}
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.message is Some(v) {
    object["message"] = @json.to_json(v)
  }
  if self.sticker is Some(v) {
    object["sticker"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessIntro with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for BusinessIntro")
  }
  let title : String? = if object.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let message : String? = if object.get("message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let sticker : Sticker? = if object.get("sticker") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { title, message, sticker }
}

///|
/// Describes the connection of the bot with a business account.
pub struct BusinessConnection {
  id : String
  user : User
  user_chat_id : Int64
  date : Int
  can_reply : Bool
  is_enabled : Bool
} derive(Show, Eq)

///|
pub fn BusinessConnection::new(
  id~ : String,
  user~ : User,
  user_chat_id~ : Int64,
  date~ : Int,
  can_reply~ : Bool,
  is_enabled~ : Bool,
) -> BusinessConnection {
  { id, user, user_chat_id, date, can_reply, is_enabled }
}

///|
pub impl @json.ToJson for BusinessConnection with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "user": @json.to_json(self.user),
    "user_chat_id": @json.to_json(self.user_chat_id),
    "date": @json.to_json(self.date),
    "can_reply": @json.to_json(self.can_reply),
    "is_enabled": @json.to_json(self.is_enabled),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessConnection with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for BusinessConnection")
  }
  let id : String = @json.from_json(object["id"], path~)
  let user : User = @json.from_json(object["user"], path~)
  let user_chat_id : Int64 = @json.from_json(object["user_chat_id"], path~)
  let date : Int = @json.from_json(object["date"], path~)
  let can_reply : Bool = @json.from_json(object["can_reply"], path~)
  let is_enabled : Bool = @json.from_json(object["is_enabled"], path~)
  { id, user, user_chat_id, date, can_reply, is_enabled }
}

///|
/// Received when messages are deleted from a connected business account.
pub struct BusinessMessagesDeleted {
  business_connection_id : String
  chat : Chat
  message_ids : Array[Int]
} derive(Show, Eq)

///|
pub fn BusinessMessagesDeleted::new(
  business_connection_id~ : String,
  chat~ : Chat,
  message_ids~ : Array[Int],
) -> BusinessMessagesDeleted {
  { business_connection_id, chat, message_ids }
}

///|
pub impl @json.ToJson for BusinessMessagesDeleted with to_json(self) {
  let object : Map[String, Json] = {
    "business_connection_id": @json.to_json(self.business_connection_id),
    "chat": @json.to_json(self.chat),
    "message_ids": @json.to_json(self.message_ids),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for BusinessMessagesDeleted with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for BusinessMessagesDeleted",
    )
  }
  let business_connection_id : String = @json.from_json(
    object["business_connection_id"],
    path~,
  )
  let chat : Chat = @json.from_json(object["chat"], path~)
  let message_ids : Array[Int] = @json.from_json(object["message_ids"], path~)
  { business_connection_id, chat, message_ids }
}
