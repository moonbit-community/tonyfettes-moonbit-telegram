///|
pub struct MessageId {
  message_id : Int
} derive(Show, Eq, ToJson, FromJson)

///|
pub fn MessageId::new(message_id~ : Int) -> MessageId {
  { message_id, }
}
