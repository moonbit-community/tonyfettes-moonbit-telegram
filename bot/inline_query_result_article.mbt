///|
pub struct InlineQueryResultArticle {
  type_ : String
  id : String
  title : String
  input_message_content : InputTextMessageContent
  reply_markup : InlineKeyboardMarkup?
  url : String?
  hide_url : Bool?
  description : String?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultArticle::new(
  id~ : String,
  title~ : String,
  input_message_content~ : InputTextMessageContent,
  type_? : String = "article",
  reply_markup? : InlineKeyboardMarkup,
  url? : String,
  hide_url? : Bool,
  description? : String,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultArticle {
  {
    type_,
    id,
    title,
    input_message_content,
    reply_markup,
    url,
    hide_url,
    description,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultArticle with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "title": @json.to_json(self.title),
    "input_message_content": @json.to_json(self.input_message_content),
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.url is Some(v) {
    object["url"] = @json.to_json(v)
  }
  if self.hide_url is Some(v) {
    object["hide_url"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    object["description"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    object["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    object["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    object["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultArticle with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultArticle",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let input_message_content : InputTextMessageContent = @json.from_json(
    object["input_message_content"],
    path~,
  )
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if object.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let hide_url : Bool? = if object.get("hide_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if object.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if object.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if object.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if object.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    title,
    input_message_content,
    reply_markup,
    url,
    hide_url,
    description,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultContact {
  type_ : String
  id : String
  phone_number : String
  first_name : String
  last_name : String?
  vcard : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultContact::new(
  id~ : String,
  phone_number~ : String,
  first_name~ : String,
  type_? : String = "contact",
  last_name? : String,
  vcard? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultContact {
  {
    type_,
    id,
    phone_number,
    first_name,
    last_name,
    vcard,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultContact with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "phone_number": @json.to_json(self.phone_number),
    "first_name": @json.to_json(self.first_name),
  }
  if self.last_name is Some(v) {
    object["last_name"] = @json.to_json(v)
  }
  if self.vcard is Some(v) {
    object["vcard"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    object["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    object["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    object["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultContact with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultContact",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let phone_number : String = @json.from_json(object["phone_number"], path~)
  let first_name : String = @json.from_json(object["first_name"], path~)
  let last_name : String? = if object.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let vcard : String? = if object.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if object.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if object.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if object.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    phone_number,
    first_name,
    last_name,
    vcard,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultLocation {
  type_ : String
  id : String
  latitude : Double
  longitude : Double
  title : String
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultLocation::new(
  id~ : String,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  type_? : String = "location",
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultLocation {
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultLocation with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
    "title": @json.to_json(self.title),
  }
  if self.horizontal_accuracy is Some(v) {
    object["horizontal_accuracy"] = @json.to_json(v)
  }
  if self.live_period is Some(v) {
    object["live_period"] = @json.to_json(v)
  }
  if self.heading is Some(v) {
    object["heading"] = @json.to_json(v)
  }
  if self.proximity_alert_radius is Some(v) {
    object["proximity_alert_radius"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    object["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    object["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    object["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultLocation with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultLocation",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let horizontal_accuracy : Double? = if object.get("horizontal_accuracy")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let live_period : Int? = if object.get("live_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let heading : Int? = if object.get("heading") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let proximity_alert_radius : Int? = if object.get("proximity_alert_radius")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if object.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if object.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if object.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultVenue {
  type_ : String
  id : String
  latitude : Double
  longitude : Double
  title : String
  address : String
  foursquare_id : String?
  foursquare_type : String?
  google_place_id : String?
  google_place_type : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultVenue::new(
  id~ : String,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  type_? : String = "venue",
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultVenue {
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultVenue with to_json(self) {
  let object : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
    "title": @json.to_json(self.title),
    "address": @json.to_json(self.address),
  }
  if self.foursquare_id is Some(v) {
    object["foursquare_id"] = @json.to_json(v)
  }
  if self.foursquare_type is Some(v) {
    object["foursquare_type"] = @json.to_json(v)
  }
  if self.google_place_id is Some(v) {
    object["google_place_id"] = @json.to_json(v)
  }
  if self.google_place_type is Some(v) {
    object["google_place_type"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    object["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    object["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    object["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    object["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    object["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InlineQueryResultVenue with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultVenue",
    )
  }
  let type_ : String = @json.from_json(object["type"], path~)
  let id : String = @json.from_json(object["id"], path~)
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let address : String = @json.from_json(object["address"], path~)
  let foursquare_id : String? = if object.get("foursquare_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let foursquare_type : String? = if object.get("foursquare_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_id : String? = if object.get("google_place_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_type : String? = if object.get("google_place_type")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if object.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if object.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if object.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if object.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if object.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}
