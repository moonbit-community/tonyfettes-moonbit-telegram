///|
pub struct Update {
  update_id : Int
  message : Message?
  edited_message : Message?
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn Update::new(
  update_id~ : Int,
  message? : Message,
  edited_message? : Message,
) -> Update {
  { update_id, message, edited_message }
}
