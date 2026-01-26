///|
pub struct Update {
  update_id : Int
  message : Message?
  edited_message : Message?
  callback_query : CallbackQuery?
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn Update::new(
  update_id~ : Int,
  message? : Message,
  edited_message? : Message,
  callback_query? : CallbackQuery,
) -> Update {
  { update_id, message, edited_message, callback_query }
}
