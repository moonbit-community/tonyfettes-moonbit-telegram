///|
pub(all) struct Update {
  update_id : Int
  message : Message?
  edited_message : Message?
} derive(Show, Eq, ToJson, FromJson)
