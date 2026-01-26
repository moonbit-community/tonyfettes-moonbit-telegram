///|
pub struct Location {
  latitude : Double
  longitude : Double
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
} derive(Show, Eq)

///|
pub fn Location::new(
  latitude~ : Double,
  longitude~ : Double,
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
) -> Location {
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
pub impl @json.ToJson for Location with to_json(self) {
  let object : Map[String, Json] = {
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
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
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Location with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Location")
  }
  let latitude : Double = @json.from_json(object["latitude"], path~)
  let longitude : Double = @json.from_json(object["longitude"], path~)
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
  {
    latitude,
    longitude,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
  }
}
