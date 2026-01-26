///|
pub struct User {
  id : Int64
  is_bot : Bool
  first_name : String
  last_name : String?
  username : String?
  language_code : String?
} derive(Show, Eq, ToJson, FromJson)

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
