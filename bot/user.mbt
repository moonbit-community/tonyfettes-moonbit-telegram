///|
pub struct User {
  id : Int64
  is_bot : Bool
  first_name : String
  last_name : String?
  username : String?
  language_code : String?
} derive(Show, Eq)

///|
pub fn User::new(
  id~ : Int64,
  is_bot~ : Bool,
  first_name~ : String,
  last_name? : String,
  username? : String,
  language_code? : String,
) -> User {
  { id, is_bot, first_name, last_name, username, language_code }
}

///|
pub impl @json.ToJson for User with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "is_bot": @json.to_json(self.is_bot),
    "first_name": @json.to_json(self.first_name),
  }
  if self.last_name is Some(v) {
    object["last_name"] = @json.to_json(v)
  }
  if self.username is Some(v) {
    object["username"] = @json.to_json(v)
  }
  if self.language_code is Some(v) {
    object["language_code"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for User with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for User")
  }
  let id : Int64 = @json.from_json(object["id"], path~)
  let is_bot : Bool = @json.from_json(object["is_bot"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
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
  let language_code : String? = if object.get("language_code") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { id, is_bot, first_name, last_name, username, language_code }
}
