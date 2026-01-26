///|
pub struct Contact {
  phone_number : String
  first_name : String
  last_name : String?
  user_id : Int64?
  vcard : String?
} derive(Show, Eq)

///|
pub fn Contact::new(
  phone_number~ : String,
  first_name~ : String,
  last_name? : String,
  user_id? : Int64,
  vcard? : String,
) -> Contact {
  { phone_number, first_name, last_name, user_id, vcard }
}

///|
pub impl @json.ToJson for Contact with to_json(self) {
  let object : Map[String, Json] = {
    "phone_number": @json.to_json(self.phone_number),
    "first_name": @json.to_json(self.first_name),
  }
  if self.last_name is Some(v) {
    object["last_name"] = @json.to_json(v)
  }
  if self.user_id is Some(v) {
    object["user_id"] = @json.to_json(v)
  }
  if self.vcard is Some(v) {
    object["vcard"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Contact with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Contact")
  }
  let phone_number : String = @json.from_json(object["phone_number"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let user_id : Int64? = if object.get("user_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let vcard : String? = if object.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { phone_number, first_name, last_name, user_id, vcard }
}
