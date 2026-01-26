///|
pub struct ForumTopicClosed {} derive(Show, Eq)

///|
pub fn ForumTopicClosed::new() -> ForumTopicClosed {
  ForumTopicClosed::{  }
}

///|
pub impl @json.ToJson for ForumTopicClosed with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ForumTopicClosed with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForumTopicClosed")
  }
  ForumTopicClosed::{  }
}

///|
pub struct ForumTopicReopened {} derive(Show, Eq)

///|
pub fn ForumTopicReopened::new() -> ForumTopicReopened {
  ForumTopicReopened::{  }
}

///|
pub impl @json.ToJson for ForumTopicReopened with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ForumTopicReopened with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(path~, "Expected object for ForumTopicReopened")
  }
  ForumTopicReopened::{  }
}

///|
pub struct GeneralForumTopicHidden {} derive(Show, Eq)

///|
pub fn GeneralForumTopicHidden::new() -> GeneralForumTopicHidden {
  GeneralForumTopicHidden::{  }
}

///|
pub impl @json.ToJson for GeneralForumTopicHidden with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for GeneralForumTopicHidden with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for GeneralForumTopicHidden",
    )
  }
  GeneralForumTopicHidden::{  }
}

///|
pub struct GeneralForumTopicUnhidden {} derive(Show, Eq)

///|
pub fn GeneralForumTopicUnhidden::new() -> GeneralForumTopicUnhidden {
  GeneralForumTopicUnhidden::{  }
}

///|
pub impl @json.ToJson for GeneralForumTopicUnhidden with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for GeneralForumTopicUnhidden with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for GeneralForumTopicUnhidden",
    )
  }
  GeneralForumTopicUnhidden::{  }
}

///|
pub struct VideoChatStarted {} derive(Show, Eq)

///|
pub fn VideoChatStarted::new() -> VideoChatStarted {
  VideoChatStarted::{  }
}

///|
pub impl @json.ToJson for VideoChatStarted with to_json(_self) {
  let obj : Map[String, Json] = {}
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoChatStarted with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoChatStarted")
  }
  VideoChatStarted::{  }
}

///|
pub struct VideoChatEnded {
  duration : Int
} derive(Show, Eq)

///|
pub fn VideoChatEnded::new(duration~ : Int) -> VideoChatEnded {
  { duration, }
}

///|
pub impl @json.ToJson for VideoChatEnded with to_json(self) {
  let obj : Map[String, Json] = { "duration": @json.to_json(self.duration) }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoChatEnded with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoChatEnded")
  }
  let duration : Int = @json.from_json(obj["duration"], path~)
  { duration, }
}

///|
pub struct VideoChatScheduled {
  start_date : Int
} derive(Show, Eq)

///|
pub fn VideoChatScheduled::new(start_date~ : Int) -> VideoChatScheduled {
  { start_date, }
}

///|
pub impl @json.ToJson for VideoChatScheduled with to_json(self) {
  let obj : Map[String, Json] = { "start_date": @json.to_json(self.start_date) }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoChatScheduled with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for VideoChatScheduled")
  }
  let start_date : Int = @json.from_json(obj["start_date"], path~)
  { start_date, }
}

///|
pub struct VideoChatParticipantsInvited {
  users : Array[User]
} derive(Show, Eq)

///|
pub fn VideoChatParticipantsInvited::new(
  users~ : Array[User],
) -> VideoChatParticipantsInvited {
  { users, }
}

///|
pub impl @json.ToJson for VideoChatParticipantsInvited with to_json(self) {
  let obj : Map[String, Json] = { "users": @json.to_json(self.users) }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for VideoChatParticipantsInvited with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for VideoChatParticipantsInvited",
    )
  }
  let users : Array[User] = @json.from_json(obj["users"], path~)
  { users, }
}

///|
pub struct MessageAutoDeleteTimerChanged {
  message_auto_delete_time : Int
} derive(Show, Eq)

///|
pub fn MessageAutoDeleteTimerChanged::new(
  message_auto_delete_time~ : Int,
) -> MessageAutoDeleteTimerChanged {
  { message_auto_delete_time, }
}

///|
pub impl @json.ToJson for MessageAutoDeleteTimerChanged with to_json(self) {
  let obj : Map[String, Json] = {
    "message_auto_delete_time": @json.to_json(self.message_auto_delete_time),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for MessageAutoDeleteTimerChanged with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for MessageAutoDeleteTimerChanged",
    )
  }
  let message_auto_delete_time : Int = @json.from_json(
    obj["message_auto_delete_time"],
    path~,
  )
  { message_auto_delete_time, }
}

///|
pub struct ChatBoostAdded {
  boost_count : Int
} derive(Show, Eq)

///|
pub fn ChatBoostAdded::new(boost_count~ : Int) -> ChatBoostAdded {
  { boost_count, }
}

///|
pub impl @json.ToJson for ChatBoostAdded with to_json(self) {
  let obj : Map[String, Json] = {
    "boost_count": @json.to_json(self.boost_count),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatBoostAdded with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatBoostAdded")
  }
  let boost_count : Int = @json.from_json(obj["boost_count"], path~)
  { boost_count, }
}

///|
pub struct ProximityAlertTriggered {
  traveler : User
  watcher : User
  distance : Int
} derive(Show, Eq)

///|
pub fn ProximityAlertTriggered::new(
  traveler~ : User,
  watcher~ : User,
  distance~ : Int,
) -> ProximityAlertTriggered {
  { traveler, watcher, distance }
}

///|
pub impl @json.ToJson for ProximityAlertTriggered with to_json(self) {
  let obj : Map[String, Json] = {
    "traveler": @json.to_json(self.traveler),
    "watcher": @json.to_json(self.watcher),
    "distance": @json.to_json(self.distance),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ProximityAlertTriggered with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ProximityAlertTriggered",
    )
  }
  let traveler : User = @json.from_json(obj["traveler"], path~)
  let watcher : User = @json.from_json(obj["watcher"], path~)
  let distance : Int = @json.from_json(obj["distance"], path~)
  { traveler, watcher, distance }
}

///|
pub struct WriteAccessAllowed {
  from_request : Bool?
  web_app_name : String?
  from_attachment_menu : Bool?
} derive(Show, Eq)

///|
pub fn WriteAccessAllowed::new(
  from_request? : Bool,
  web_app_name? : String,
  from_attachment_menu? : Bool,
) -> WriteAccessAllowed {
  { from_request, web_app_name, from_attachment_menu }
}

///|
pub impl @json.ToJson for WriteAccessAllowed with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.from_request is Some(v) {
    obj["from_request"] = @json.to_json(v)
  }
  if self.web_app_name is Some(v) {
    obj["web_app_name"] = @json.to_json(v)
  }
  if self.from_attachment_menu is Some(v) {
    obj["from_attachment_menu"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for WriteAccessAllowed with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for WriteAccessAllowed")
  }
  let from_request : Bool? = if obj.get("from_request") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let web_app_name : String? = if obj.get("web_app_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let from_attachment_menu : Bool? = if obj.get("from_attachment_menu")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { from_request, web_app_name, from_attachment_menu }
}

///|
pub struct WebAppData {
  data : String
  button_text : String
} derive(Show, Eq)

///|
pub fn WebAppData::new(data~ : String, button_text~ : String) -> WebAppData {
  { data, button_text }
}

///|
pub impl @json.ToJson for WebAppData with to_json(self) {
  let obj : Map[String, Json] = {
    "data": @json.to_json(self.data),
    "button_text": @json.to_json(self.button_text),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for WebAppData with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for WebAppData")
  }
  let data : String = @json.from_json(obj["data"], path~)
  let button_text : String = @json.from_json(obj["button_text"], path~)
  { data, button_text }
}
