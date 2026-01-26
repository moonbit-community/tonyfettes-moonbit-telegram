///|
pub(all) enum ChatType {
  Private
  Group
  Supergroup
  Channel
} derive(Show, Eq)

///|
pub impl ToJson for ChatType with to_json(self) {
  match self {
    Private => "private".to_json()
    Group => "group".to_json()
    Supergroup => "supergroup".to_json()
    Channel => "channel".to_json()
  }
}

///|
pub impl @json.FromJson for ChatType with from_json(json, path) {
  guard json is String(s) else {
    raise @json.JsonDecodeError((path, "Expected string for ChatType"))
  }
  match s {
    "private" => Private
    "group" => Group
    "supergroup" => Supergroup
    "channel" => Channel
    _ => raise @json.JsonDecodeError((path, "Unknown ChatType: \{s}"))
  }
}

///|
pub(all) struct Chat {
  id : Int64
  type_ : ChatType
  title : String?
  username : String?
  first_name : String?
  last_name : String?
} derive(Show, Eq)

///|
pub fn Chat::new(
  id~ : Int64,
  type_~ : ChatType,
  title? : String,
  username? : String,
  first_name? : String,
  last_name? : String,
) -> Chat {
  { id, type_, title, username, first_name, last_name }
}

///|
pub impl ToJson for Chat with to_json(self) {
  let obj : Map[String, Json] = {
    "id": self.id.to_json(),
    "type": self.type_.to_json(),
  }
  if self.title is Some(v) {
    obj["title"] = v.to_json()
  }
  if self.username is Some(v) {
    obj["username"] = v.to_json()
  }
  if self.first_name is Some(v) {
    obj["first_name"] = v.to_json()
  }
  if self.last_name is Some(v) {
    obj["last_name"] = v.to_json()
  }
  obj.to_json()
}

///|
pub impl @json.FromJson for Chat with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError((path, "Expected object for Chat"))
  }
  let id : Int64 = @json.from_json(obj["id"], path~)
  let type_ : ChatType = @json.from_json(obj["type"], path~)
  let title : String? = if obj.get("title") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let username : String? = if obj.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let first_name : String? = if obj.get("first_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_name : String? = if obj.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, type_, title, username, first_name, last_name }
}
