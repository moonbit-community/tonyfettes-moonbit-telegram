///|
pub(all) struct User {
  id : Int64
  is_bot : Bool
  first_name : String
  last_name : String?
  username : String?
  language_code : String?
} derive(Show, Eq, ToJson, FromJson)
