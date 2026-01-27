///|
pub struct PhotoSizePlaceholder {
  file_id : String
  file_unique_id : String
  width : Int
  height : Int
} derive(Show, Eq)

///|
pub fn PhotoSizePlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
  width~ : Int,
  height~ : Int,
) -> PhotoSizePlaceholder {
  { file_id, file_unique_id, width, height }
}

///|
pub impl @json.ToJson for PhotoSizePlaceholder with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "width": @json.to_json(self.width),
    "height": @json.to_json(self.height),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PhotoSizePlaceholder with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for PhotoSizePlaceholder",
    )
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let width : Int = @json.from_json(obj["width"], path~)
  let height : Int = @json.from_json(obj["height"], path~)
  { file_id, file_unique_id, width, height }
}

///|
pub struct SharedUser {
  user_id : Int64
  first_name : String?
  last_name : String?
  username : String?
  photo : Array[PhotoSizePlaceholder]?
} derive(Show, Eq)

///|
pub fn SharedUser::new(
  user_id~ : Int64,
  first_name? : String,
  last_name? : String,
  username? : String,
  photo? : Array[PhotoSizePlaceholder],
) -> SharedUser {
  { user_id, first_name, last_name, username, photo }
}

///|
pub impl @json.ToJson for SharedUser with to_json(self) {
  let obj : Map[String, Json] = { "user_id": @json.to_json(self.user_id) }
  if self.first_name is Some(v) {
    obj["first_name"] = @json.to_json(v)
  }
  if self.last_name is Some(v) {
    obj["last_name"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    obj["username"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    obj["photo"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for SharedUser with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for SharedUser")
  }
  let user_id : Int64 = @json.from_json(obj["user_id"], path~)
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
  let username : String? = if obj.get("username") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo : Array[PhotoSizePlaceholder]? = if obj.get("photo") is Some(v) {
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
  let obj : Map[String, Json] = {
    "request_id": @json.to_json(self.request_id),
    "users": @json.to_json(self.users),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for UsersShared with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for UsersShared")
  }
  let request_id : Int = @json.from_json(obj["request_id"], path~)
  let users : Array[SharedUser] = @json.from_json(obj["users"], path~)
  { request_id, users }
}

///|
pub struct ChatShared {
  request_id : Int
  chat_id : Int64
  title : String?
  username : String?
  photo : Array[PhotoSizePlaceholder]?
} derive(Show, Eq)

///|
pub fn ChatShared::new(
  request_id~ : Int,
  chat_id~ : Int64,
  title? : String,
  username? : String,
  photo? : Array[PhotoSizePlaceholder],
) -> ChatShared {
  { request_id, chat_id, title, username, photo }
}

///|
pub impl @json.ToJson for ChatShared with to_json(self) {
  let obj : Map[String, Json] = {
    "request_id": @json.to_json(self.request_id),
    "chat_id": @json.to_json(self.chat_id),
  }
  if self.title is Some(v) {
    obj["title"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    obj["username"] = @json.to_json(v)
  }
  if self.photo is Some(v) {
    obj["photo"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatShared with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatShared")
  }
  let request_id : Int = @json.from_json(obj["request_id"], path~)
  let chat_id : Int64 = @json.from_json(obj["chat_id"], path~)
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
  let photo : Array[PhotoSizePlaceholder]? = if obj.get("photo") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { request_id, chat_id, title, username, photo }
}
