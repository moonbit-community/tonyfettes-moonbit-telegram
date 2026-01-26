///|
pub struct Venue {
  location : Location
  title : String
  address : String
  foursquare_id : String?
  foursquare_type : String?
  google_place_id : String?
  google_place_type : String?
} derive(Show, Eq)

///|
pub fn Venue::new(
  location~ : Location,
  title~ : String,
  address~ : String,
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
) -> Venue {
  {
    location,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}

///|
pub impl @json.ToJson for Venue with to_json(self) {
  let object : Map[String, Json] = {
    "location": @json.to_json(self.location),
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
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Venue with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Venue")
  }
  let location : Location = @json.from_json(object["location"], path~)
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
  {
    location,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
  }
}
