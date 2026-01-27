///|
pub struct InputLinkPreviewOptions {
  is_disabled : Bool?
  url : String?
  prefer_small_media : Bool?
  prefer_large_media : Bool?
  show_above_text : Bool?
} derive(Show, Eq)

///|
pub fn InputLinkPreviewOptions::new(
  is_disabled? : Bool,
  url? : String,
  prefer_small_media? : Bool,
  prefer_large_media? : Bool,
  show_above_text? : Bool,
) -> InputLinkPreviewOptions {
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub impl @json.ToJson for InputLinkPreviewOptions with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    obj["is_disabled"] = @json.to_json(v)
  }
  if self.url is Some(v) {
    obj["url"] = @json.to_json(v)
  }
  if self.prefer_small_media is Some(v) {
    obj["prefer_small_media"] = @json.to_json(v)
  }
  if self.prefer_large_media is Some(v) {
    obj["prefer_large_media"] = @json.to_json(v)
  }
  if self.show_above_text is Some(v) {
    obj["show_above_text"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputLinkPreviewOptions with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputLinkPreviewOptions",
    )
  }
  let is_disabled : Bool? = if obj.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if obj.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_small_media : Bool? = if obj.get("prefer_small_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_large_media : Bool? = if obj.get("prefer_large_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_above_text : Bool? = if obj.get("show_above_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub struct InputTextMessageContent {
  message_text : String
  parse_mode : String?
  entities : Array[MessageEntity]?
  link_preview_options : InputLinkPreviewOptions?
} derive(Show, Eq)

///|
pub fn InputTextMessageContent::new(
  message_text~ : String,
  parse_mode? : String,
  entities? : Array[MessageEntity],
  link_preview_options? : InputLinkPreviewOptions,
) -> InputTextMessageContent {
  { message_text, parse_mode, entities, link_preview_options }
}

///|
pub impl @json.ToJson for InputTextMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "message_text": @json.to_json(self.message_text),
  }
  if self.parse_mode is Some(v) {
    obj["parse_mode"] = @json.to_json(v)
  }
  if self.entities is Some(v) {
    obj["entities"] = @json.to_json(v)
  }
  if self.link_preview_options is Some(v) {
    obj["link_preview_options"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputTextMessageContent with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputTextMessageContent",
    )
  }
  let message_text : String = @json.from_json(obj["message_text"], path~)
  let parse_mode : String? = if obj.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if obj.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : InputLinkPreviewOptions? = if obj.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { message_text, parse_mode, entities, link_preview_options }
}

///|
pub struct InputLocationMessageContent {
  latitude : Double
  longitude : Double
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
} derive(Show, Eq)

///|
pub fn InputLocationMessageContent::new(
  latitude~ : Double,
  longitude~ : Double,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
) -> InputLocationMessageContent {
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}

///|
pub impl @json.ToJson for InputLocationMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
  }
  if self.horizontal_accuracy is Some(v) {
    obj["horizontal_accuracy"] = @json.to_json(v)
  }
  if self.live_period is Some(v) {
    obj["live_period"] = @json.to_json(v)
  }
  if self.heading is Some(v) {
    obj["heading"] = @json.to_json(v)
  }
  if self.proximity_alert_radius is Some(v) {
    obj["proximity_alert_radius"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputLocationMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputLocationMessageContent",
    )
  }
  let latitude : Double = @json.from_json(obj["latitude"], path~)
  let longitude : Double = @json.from_json(obj["longitude"], path~)
  let horizontal_accuracy : Double? = if obj.get("horizontal_accuracy")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let live_period : Int? = if obj.get("live_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let heading : Int? = if obj.get("heading") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let proximity_alert_radius : Int? = if obj.get("proximity_alert_radius")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}

///|
pub struct InputVenueMessageContent {
  latitude : Double
  longitude : Double
  title : String
  address : String
  foursquare_id : String?
  foursquare_type : String?
  google_place_id : String?
  google_place_type : String?
} derive(Show, Eq)

///|
pub fn InputVenueMessageContent::new(
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
) -> InputVenueMessageContent {
  {
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}

///|
pub impl @json.ToJson for InputVenueMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
    "title": @json.to_json(self.title),
    "address": @json.to_json(self.address),
  }
  if self.foursquare_id is Some(v) {
    obj["foursquare_id"] = @json.to_json(v)
  }
  if self.foursquare_type is Some(v) {
    obj["foursquare_type"] = @json.to_json(v)
  }
  if self.google_place_id is Some(v) {
    obj["google_place_id"] = @json.to_json(v)
  }
  if self.google_place_type is Some(v) {
    obj["google_place_type"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputVenueMessageContent with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputVenueMessageContent",
    )
  }
  let latitude : Double = @json.from_json(obj["latitude"], path~)
  let longitude : Double = @json.from_json(obj["longitude"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let address : String = @json.from_json(obj["address"], path~)
  let foursquare_id : String? = if obj.get("foursquare_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let foursquare_type : String? = if obj.get("foursquare_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_id : String? = if obj.get("google_place_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_type : String? = if obj.get("google_place_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}

///|
pub struct InputContactMessageContent {
  phone_number : String
  first_name : String
  last_name : String?
  vcard : String?
} derive(Show, Eq)

///|
pub fn InputContactMessageContent::new(
  phone_number~ : String,
  first_name~ : String,
  last_name? : String,
  vcard? : String,
) -> InputContactMessageContent {
  { phone_number, first_name, last_name, vcard }
}

///|
pub impl @json.ToJson for InputContactMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "phone_number": @json.to_json(self.phone_number),
    "first_name": @json.to_json(self.first_name),
  }
  if self.last_name is Some(v) {
    obj["last_name"] = @json.to_json(v)
  }
  if self.vcard is Some(v) {
    obj["vcard"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputContactMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputContactMessageContent",
    )
  }
  let phone_number : String = @json.from_json(obj["phone_number"], path~)
  let first_name : String = @json.from_json(obj["first_name"], path~)
  let last_name : String? = if obj.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let vcard : String? = if obj.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { phone_number, first_name, last_name, vcard }
}

///|
pub struct InputInvoiceMessageContent {
  title : String
  description : String
  payload : String
  provider_token : String?
  currency : String
  prices : Array[LabeledPrice]
  max_tip_amount : Int?
  suggested_tip_amounts : Array[Int]?
  provider_data : String?
  photo_url : String?
  photo_size : Int?
  photo_width : Int?
  photo_height : Int?
  need_name : Bool?
  need_phone_number : Bool?
  need_email : Bool?
  need_shipping_address : Bool?
  send_phone_number_to_provider : Bool?
  send_email_to_provider : Bool?
  is_flexible : Bool?
} derive(Show, Eq)

///|
pub fn InputInvoiceMessageContent::new(
  title~ : String,
  description~ : String,
  payload~ : String,
  provider_token? : String,
  currency~ : String,
  prices~ : Array[LabeledPrice],
  max_tip_amount? : Int,
  suggested_tip_amounts? : Array[Int],
  provider_data? : String,
  photo_url? : String,
  photo_size? : Int,
  photo_width? : Int,
  photo_height? : Int,
  need_name? : Bool,
  need_phone_number? : Bool,
  need_email? : Bool,
  need_shipping_address? : Bool,
  send_phone_number_to_provider? : Bool,
  send_email_to_provider? : Bool,
  is_flexible? : Bool,
) -> InputInvoiceMessageContent {
  {
    title,
    description,
    payload,
    provider_token,
    currency,
    prices,
    max_tip_amount,
    suggested_tip_amounts,
    provider_data,
    photo_url,
    photo_size,
    photo_width,
    photo_height,
    need_name,
    need_phone_number,
    need_email,
    need_shipping_address,
    send_phone_number_to_provider,
    send_email_to_provider,
    is_flexible,
  }
}

///|
pub impl @json.ToJson for InputInvoiceMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "title": @json.to_json(self.title),
    "description": @json.to_json(self.description),
    "payload": @json.to_json(self.payload),
    "currency": @json.to_json(self.currency),
    "prices": @json.to_json(self.prices),
  }
  if self.provider_token is Some(v) {
    obj["provider_token"] = @json.to_json(v)
  }
  if self.max_tip_amount is Some(v) {
    obj["max_tip_amount"] = @json.to_json(v)
  }
  if self.suggested_tip_amounts is Some(v) {
    obj["suggested_tip_amounts"] = @json.to_json(v)
  }
  if self.provider_data is Some(v) {
    obj["provider_data"] = @json.to_json(v)
  }
  if self.photo_url is Some(v) {
    obj["photo_url"] = @json.to_json(v)
  }
  if self.photo_size is Some(v) {
    obj["photo_size"] = @json.to_json(v)
  }
  if self.photo_width is Some(v) {
    obj["photo_width"] = @json.to_json(v)
  }
  if self.photo_height is Some(v) {
    obj["photo_height"] = @json.to_json(v)
  }
  if self.need_name is Some(v) {
    obj["need_name"] = @json.to_json(v)
  }
  if self.need_phone_number is Some(v) {
    obj["need_phone_number"] = @json.to_json(v)
  }
  if self.need_email is Some(v) {
    obj["need_email"] = @json.to_json(v)
  }
  if self.need_shipping_address is Some(v) {
    obj["need_shipping_address"] = @json.to_json(v)
  }
  if self.send_phone_number_to_provider is Some(v) {
    obj["send_phone_number_to_provider"] = @json.to_json(v)
  }
  if self.send_email_to_provider is Some(v) {
    obj["send_email_to_provider"] = @json.to_json(v)
  }
  if self.is_flexible is Some(v) {
    obj["is_flexible"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputInvoiceMessageContent with from_json(
  json,
  path,
) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputInvoiceMessageContent",
    )
  }
  let title : String = @json.from_json(obj["title"], path~)
  let description : String = @json.from_json(obj["description"], path~)
  let payload : String = @json.from_json(obj["payload"], path~)
  let provider_token : String? = if obj.get("provider_token") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let currency : String = @json.from_json(obj["currency"], path~)
  let prices : Array[LabeledPrice] = @json.from_json(obj["prices"], path~)
  let max_tip_amount : Int? = if obj.get("max_tip_amount") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let suggested_tip_amounts : Array[Int]? = if obj.get("suggested_tip_amounts")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let provider_data : String? = if obj.get("provider_data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_url : String? = if obj.get("photo_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_size : Int? = if obj.get("photo_size") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_width : Int? = if obj.get("photo_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let photo_height : Int? = if obj.get("photo_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_name : Bool? = if obj.get("need_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_phone_number : Bool? = if obj.get("need_phone_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_email : Bool? = if obj.get("need_email") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let need_shipping_address : Bool? = if obj.get("need_shipping_address")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let send_phone_number_to_provider : Bool? = if obj.get(
      "send_phone_number_to_provider",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let send_email_to_provider : Bool? = if obj.get("send_email_to_provider")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_flexible : Bool? = if obj.get("is_flexible") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    title,
    description,
    payload,
    provider_token,
    currency,
    prices,
    max_tip_amount,
    suggested_tip_amounts,
    provider_data,
    photo_url,
    photo_size,
    photo_width,
    photo_height,
    need_name,
    need_phone_number,
    need_email,
    need_shipping_address,
    send_phone_number_to_provider,
    send_email_to_provider,
    is_flexible,
  }
}

///|
pub(all) enum InputMessageContent {
  Text(InputTextMessageContent)
  Location(InputLocationMessageContent)
  Venue(InputVenueMessageContent)
  Contact(InputContactMessageContent)
  Invoice(InputInvoiceMessageContent)
} derive(Show, Eq)

///|
pub impl @json.ToJson for InputMessageContent with to_json(self) {
  match self {
    Text(v) => @json.to_json(v)
    Location(v) => @json.to_json(v)
    Venue(v) => @json.to_json(v)
    Contact(v) => @json.to_json(v)
    Invoice(v) => @json.to_json(v)
  }
}

///|
pub impl @json.FromJson for InputMessageContent with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputMessageContent",
    )
  }
  // Determine type based on fields present
  // Text: has message_text
  // Location: has latitude, longitude (but not title/address)
  // Venue: has latitude, longitude, title, address
  // Contact: has phone_number, first_name
  // Invoice: has title, description, payload, currency, prices
  if obj.contains("message_text") {
    Text(@json.from_json(json, path~))
  } else if obj.contains("phone_number") && obj.contains("first_name") {
    Contact(@json.from_json(json, path~))
  } else if obj.contains("payload") &&
    obj.contains("currency") &&
    obj.contains("prices") {
    Invoice(@json.from_json(json, path~))
  } else if obj.contains("latitude") &&
    obj.contains("longitude") &&
    obj.contains("title") &&
    obj.contains("address") {
    Venue(@json.from_json(json, path~))
  } else if obj.contains("latitude") && obj.contains("longitude") {
    Location(@json.from_json(json, path~))
  } else {
    raise @json.JsonDecodeError(
      path~,
      "Cannot determine InputMessageContent type from fields",
    )
  }
}
