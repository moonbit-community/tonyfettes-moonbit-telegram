///|
test "PassportFile JSON round-trip" {
  let file = PassportFile::new(
    file_id="file123",
    file_unique_id="unique456",
    file_size=1024,
    file_date=1609459200,
  )
  let json = @json.to_json(file)
  let parsed : PassportFile = @json.from_json(json)
  inspect(parsed.file_id, content="file123")
  inspect(parsed.file_unique_id, content="unique456")
  inspect(parsed.file_size, content="1024")
  inspect(parsed.file_date, content="1609459200")
}

///|
test "EncryptedCredentials JSON round-trip" {
  let credentials = EncryptedCredentials::new(
    data="encrypted_data",
    hash="hash_value",
    secret="secret_key",
  )
  let json = @json.to_json(credentials)
  let parsed : EncryptedCredentials = @json.from_json(json)
  inspect(parsed.data, content="encrypted_data")
  inspect(parsed.hash, content="hash_value")
  inspect(parsed.secret, content="secret_key")
}

///|
test "EncryptedPassportElement JSON round-trip with minimal fields" {
  let element = EncryptedPassportElement::new(
    type_="personal_details",
    hash="element_hash",
  )
  let json = @json.to_json(element)
  let parsed : EncryptedPassportElement = @json.from_json(json)
  inspect(parsed.type_, content="personal_details")
  inspect(parsed.hash, content="element_hash")
  inspect(parsed.data, content="None")
  inspect(parsed.phone_number, content="None")
  inspect(parsed.email, content="None")
  inspect(parsed.files, content="None")
  inspect(parsed.front_side, content="None")
  inspect(parsed.reverse_side, content="None")
  inspect(parsed.selfie, content="None")
  inspect(parsed.translation, content="None")
}

///|
test "EncryptedPassportElement JSON round-trip with all fields" {
  let file1 = PassportFile::new(
    file_id="file1",
    file_unique_id="unique1",
    file_size=512,
    file_date=1609459200,
  )
  let file2 = PassportFile::new(
    file_id="file2",
    file_unique_id="unique2",
    file_size=1024,
    file_date=1609459300,
  )
  let front = PassportFile::new(
    file_id="front_file",
    file_unique_id="front_unique",
    file_size=2048,
    file_date=1609459400,
  )
  let reverse = PassportFile::new(
    file_id="reverse_file",
    file_unique_id="reverse_unique",
    file_size=2048,
    file_date=1609459500,
  )
  let selfie_file = PassportFile::new(
    file_id="selfie_file",
    file_unique_id="selfie_unique",
    file_size=4096,
    file_date=1609459600,
  )
  let translation_file = PassportFile::new(
    file_id="translation_file",
    file_unique_id="translation_unique",
    file_size=3072,
    file_date=1609459700,
  )
  let element = EncryptedPassportElement::new(
    type_="driver_license",
    hash="full_hash",
    data="encrypted_data",
    phone_number="+1234567890",
    email="test@example.com",
    files=[file1, file2],
    front_side=front,
    reverse_side=reverse,
    selfie=selfie_file,
    translation=[translation_file],
  )
  let json = @json.to_json(element)
  let parsed : EncryptedPassportElement = @json.from_json(json)
  inspect(parsed.type_, content="driver_license")
  inspect(parsed.hash, content="full_hash")
  inspect(parsed.data, content="Some(\"encrypted_data\")")
  inspect(parsed.phone_number, content="Some(\"+1234567890\")")
  inspect(parsed.email, content="Some(\"test@example.com\")")
  guard parsed.files is Some(files) else { fail("Expected files") }
  inspect(files.length(), content="2")
  inspect(files[0].file_id, content="file1")
  guard parsed.front_side is Some(fs) else { fail("Expected front_side") }
  inspect(fs.file_id, content="front_file")
  guard parsed.reverse_side is Some(rs) else { fail("Expected reverse_side") }
  inspect(rs.file_id, content="reverse_file")
  guard parsed.selfie is Some(sf) else { fail("Expected selfie") }
  inspect(sf.file_id, content="selfie_file")
  guard parsed.translation is Some(trans) else { fail("Expected translation") }
  inspect(trans.length(), content="1")
  inspect(trans[0].file_id, content="translation_file")
}

///|
test "PassportData JSON round-trip" {
  let file = PassportFile::new(
    file_id="doc_file",
    file_unique_id="doc_unique",
    file_size=2048,
    file_date=1609459200,
  )
  let element1 = EncryptedPassportElement::new(
    type_="personal_details",
    hash="hash1",
    data="personal_data_encrypted",
  )
  let element2 = EncryptedPassportElement::new(
    type_="passport",
    hash="hash2",
    front_side=file,
  )
  let credentials = EncryptedCredentials::new(
    data="credentials_data",
    hash="credentials_hash",
    secret="credentials_secret",
  )
  let passport_data = PassportData::new(data=[element1, element2], credentials~)
  let json = @json.to_json(passport_data)
  let parsed : PassportData = @json.from_json(json)
  inspect(parsed.data.length(), content="2")
  inspect(parsed.data[0].type_, content="personal_details")
  inspect(parsed.data[1].type_, content="passport")
  guard parsed.data[1].front_side is Some(fs) else {
    fail("Expected front_side")
  }
  inspect(fs.file_id, content="doc_file")
  inspect(parsed.credentials.data, content="credentials_data")
  inspect(parsed.credentials.hash, content="credentials_hash")
  inspect(parsed.credentials.secret, content="credentials_secret")
}
