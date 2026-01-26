///|
test "Venue JSON round-trip" {
  let location = Location::new(latitude=40.7484, longitude=-73.9857)
  let venue = Venue::new(
    location~,
    title="Empire State Building",
    address="350 Fifth Avenue, New York, NY",
    foursquare_id="4b5a0c13f964a520e5cf28e3",
    google_place_id="ChIJaXQRs6lZwokRY6EFpJnhNNE",
  )
  let json = @json.to_json(venue)
  let parsed : Venue = @json.from_json(json)
  inspect(parsed.title, content="Empire State Building")
  inspect(parsed.address, content="350 Fifth Avenue, New York, NY")
  inspect(parsed.foursquare_id, content="Some(\"4b5a0c13f964a520e5cf28e3\")")
  inspect(
    parsed.google_place_id,
    content="Some(\"ChIJaXQRs6lZwokRY6EFpJnhNNE\")",
  )
  inspect(parsed.foursquare_type, content="None")
  inspect(parsed.google_place_type, content="None")
}

///|
test "Venue JSON minimal" {
  let location = Location::new(latitude=48.8584, longitude=2.2945)
  let venue = Venue::new(
    location~,
    title="Eiffel Tower",
    address="Champ de Mars, Paris",
  )
  let json = @json.to_json(venue)
  let parsed : Venue = @json.from_json(json)
  inspect(parsed.title, content="Eiffel Tower")
  inspect(parsed.location.latitude, content="48.8584")
}
