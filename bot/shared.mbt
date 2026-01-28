///|
pub struct SharedUser {
  user_id : Int64
  first_name : String?
  last_name : String?
  username : String?
  photo : Array[PhotoSize]?
} derive(Show, Eq)

///|
pub fn SharedUser::new(
  user_id~ : Int64,
  first_name? : String,
  last_name? : String,
  username? : String,
  photo? : Array[PhotoSize],
) -> SharedUser {
  { user_id, first_name, last_name, username, photo }
}

///|
pub impl @json.ToJson for SharedUser with to_json(self) {
  let object : Map[String, Json] = { "user_id": @json.to_json(self.user_id) }
  if self.first_name is Some(v) {
    object["first_name"] = @json.to_json(v)
  }
  if self.last_name is Some(v) {
    object["last_name"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    object["username"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    object["photo"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SharedUser with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SharedUser")
  }
  let user_id : Int64 = @json.from_json(object["user_id"], path~)
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
  let username : String? = if object.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo : Array[PhotoSize]? = if object.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { user_id, first_name, last_name, username, photo }
}

///|
pub struct UsersShared {
  request_id : Int
  users : Array[SharedUser]
} derive(Show, Eq)

///|
pub fn UsersShared::new(
  request_id~ : Int,
  users~ : Array[SharedUser],
) -> UsersShared {
  { request_id, users }
}

///|
pub impl @json.ToJson for UsersShared with to_json(self) {
  let object : Map[String, Json] = {
    "request_id": @json.to_json(self.request_id),
    "users": @json.to_json(self.users),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for UsersShared with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for UsersShared")
  }
  let request_id : Int = @json.from_json(object["request_id"], path~)
  let users : Array[SharedUser] = @json.from_json(object["users"], path~)
  { request_id, users }
}

///|
pub struct ChatShared {
  request_id : Int
  chat_id : Int64
  title : String?
  username : String?
  photo : Array[PhotoSize]?
} derive(Show, Eq)

///|
pub fn ChatShared::new(
  request_id~ : Int,
  chat_id~ : Int64,
  title? : String,
  username? : String,
  photo? : Array[PhotoSize],
) -> ChatShared {
  { request_id, chat_id, title, username, photo }
}

///|
pub impl @json.ToJson for ChatShared with to_json(self) {
  let object : Map[String, Json] = {
    "request_id": @json.to_json(self.request_id),
    "chat_id": @json.to_json(self.chat_id),
  }
  if self.title is Some(v) {
    object["title"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    object["username"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    object["photo"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChatShared with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatShared")
  }
  let request_id : Int = @json.from_json(object["request_id"], path~)
  let chat_id : Int64 = @json.from_json(object["chat_id"], path~)
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
  let photo : Array[PhotoSize]? = if object.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { request_id, chat_id, title, username, photo }
}
