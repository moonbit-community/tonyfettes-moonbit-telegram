///|
pub struct WebhookInfo {
  url : String
  has_custom_certificate : Bool
  pending_update_count : Int
  ip_address : String?
  last_error_date : Int?
  last_error_message : String?
  last_synchronization_error_date : Int?
  max_connections : Int?
  allowed_updates : Array[String]?
} derive(Show, Eq)

///|
pub fn WebhookInfo::new(
  url~ : String,
  has_custom_certificate~ : Bool,
  pending_update_count~ : Int,
  ip_address? : String,
  last_error_date? : Int,
  last_error_message? : String,
  last_synchronization_error_date? : Int,
  max_connections? : Int,
  allowed_updates? : Array[String],
) -> WebhookInfo {
  {
    url,
    has_custom_certificate,
    pending_update_count,
    ip_address,
    last_error_date,
    last_error_message,
    last_synchronization_error_date,
    max_connections,
    allowed_updates,
  }
}

///|
pub impl @json.ToJson for WebhookInfo with to_json(self) {
  let object : Map[String, Json] = {
    "url": @json.to_json(self.url),
    "has_custom_certificate": @json.to_json(self.has_custom_certificate),
    "pending_update_count": @json.to_json(self.pending_update_count),
  }
  if self.ip_address is Some(v) {
    object["ip_address"] = @json.to_json(v)
  }
  if self.last_error_date is Some(v) {
    object["last_error_date"] = @json.to_json(v)
  }
  if self.last_error_message is Some(v) {
    object["last_error_message"] = @json.to_json(v)
  }
  if self.last_synchronization_error_date is Some(v) {
    object["last_synchronization_error_date"] = @json.to_json(v)
  }
  if self.max_connections is Some(v) {
    object["max_connections"] = @json.to_json(v)
  }
  if self.allowed_updates is Some(v) {
    object["allowed_updates"] = @json.ToJson::to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for WebhookInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for WebhookInfo")
  }
  let url : String = @json.from_json(object["url"], path~)
  let has_custom_certificate : Bool = @json.from_json(
    object["has_custom_certificate"],
    path~,
  )
  let pending_update_count : Int = @json.from_json(
    object["pending_update_count"],
    path~,
  )
  let ip_address : String? = if object.get("ip_address") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_error_date : Int? = if object.get("last_error_date") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_error_message : String? = if object.get("last_error_message") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let last_synchronization_error_date : Int? =
    if object.get("last_synchronization_error_date") is Some(v) {
      Some(@json.from_json(v, path~))
    } else {
      None
    }
  let max_connections : Int? = if object.get("max_connections") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let allowed_updates : Array[String]? = if object.get("allowed_updates") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    url,
    has_custom_certificate,
    pending_update_count,
    ip_address,
    last_error_date,
    last_error_message,
    last_synchronization_error_date,
    max_connections,
    allowed_updates,
  }
}
