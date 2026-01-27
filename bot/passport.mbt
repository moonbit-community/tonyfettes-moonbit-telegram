///|
pub struct PassportFile {
  file_id : String
  file_unique_id : String
  file_size : Int
  file_date : Int
} derive(Show, Eq)

///|
pub fn PassportFile::new(
  file_id~ : String,
  file_unique_id~ : String,
  file_size~ : Int,
  file_date~ : Int,
) -> PassportFile {
  { file_id, file_unique_id, file_size, file_date }
}

///|
pub impl @json.ToJson for PassportFile with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
    "file_size": @json.to_json(self.file_size),
    "file_date": @json.to_json(self.file_date),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PassportFile with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for PassportFile")
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  let file_size : Int = @json.from_json(obj["file_size"], path~)
  let file_date : Int = @json.from_json(obj["file_date"], path~)
  { file_id, file_unique_id, file_size, file_date }
}

///|
pub struct EncryptedCredentials {
  data : String
  hash : String
  secret : String
} derive(Show, Eq)

///|
pub fn EncryptedCredentials::new(
  data~ : String,
  hash~ : String,
  secret~ : String,
) -> EncryptedCredentials {
  { data, hash, secret }
}

///|
pub impl @json.ToJson for EncryptedCredentials with to_json(self) {
  let obj : Map[String, Json] = {
    "data": @json.to_json(self.data),
    "hash": @json.to_json(self.hash),
    "secret": @json.to_json(self.secret),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for EncryptedCredentials with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for EncryptedCredentials",
    )
  }
  let data : String = @json.from_json(obj["data"], path~)
  let hash : String = @json.from_json(obj["hash"], path~)
  let secret : String = @json.from_json(obj["secret"], path~)
  { data, hash, secret }
}

///|
pub struct EncryptedPassportElement {
  type_ : String
  data : String?
  phone_number : String?
  email : String?
  files : Array[PassportFile]?
  front_side : PassportFile?
  reverse_side : PassportFile?
  selfie : PassportFile?
  translation : Array[PassportFile]?
  hash : String
} derive(Show, Eq)

///|
pub fn EncryptedPassportElement::new(
  type_~ : String,
  hash~ : String,
  data? : String,
  phone_number? : String,
  email? : String,
  files? : Array[PassportFile],
  front_side? : PassportFile,
  reverse_side? : PassportFile,
  selfie? : PassportFile,
  translation? : Array[PassportFile],
) -> EncryptedPassportElement {
  {
    type_,
    data,
    phone_number,
    email,
    files,
    front_side,
    reverse_side,
    selfie,
    translation,
    hash,
  }
}

///|
pub impl @json.ToJson for EncryptedPassportElement with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "hash": @json.to_json(self.hash),
  }
  if self.data is Some(v) {
    obj["data"] = @json.to_json(v)
  }
  if self.phone_number is Some(v) {
    obj["phone_number"] = @json.to_json(v)
  }
  if self.email is Some(v) {
    obj["email"] = @json.to_json(v)
  }
  if self.files is Some(v) {
    obj["files"] = @json.to_json(v)
  }
  if self.front_side is Some(v) {
    obj["front_side"] = @json.to_json(v)
  }
  if self.reverse_side is Some(v) {
    obj["reverse_side"] = @json.to_json(v)
  }
  if self.selfie is Some(v) {
    obj["selfie"] = @json.to_json(v)
  }
  if self.translation is Some(v) {
    obj["translation"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for EncryptedPassportElement with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for EncryptedPassportElement",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let hash : String = @json.from_json(obj["hash"], path~)
  let data : String? = if obj.get("data") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let phone_number : String? = if obj.get("phone_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let email : String? = if obj.get("email") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let files : Array[PassportFile]? = if obj.get("files") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let front_side : PassportFile? = if obj.get("front_side") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reverse_side : PassportFile? = if obj.get("reverse_side") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let selfie : PassportFile? = if obj.get("selfie") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let translation : Array[PassportFile]? = if obj.get("translation") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    data,
    phone_number,
    email,
    files,
    front_side,
    reverse_side,
    selfie,
    translation,
    hash,
  }
}

///|
pub struct PassportData {
  data : Array[EncryptedPassportElement]
  credentials : EncryptedCredentials
} derive(Show, Eq)

///|
pub fn PassportData::new(
  data~ : Array[EncryptedPassportElement],
  credentials~ : EncryptedCredentials,
) -> PassportData {
  { data, credentials }
}

///|
pub impl @json.ToJson for PassportData with to_json(self) {
  let obj : Map[String, Json] = {
    "data": @json.to_json(self.data),
    "credentials": @json.to_json(self.credentials),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for PassportData with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for PassportData")
  }
  let data : Array[EncryptedPassportElement] = @json.from_json(
    obj["data"],
    path~,
  )
  let credentials : EncryptedCredentials = @json.from_json(
    obj["credentials"],
    path~,
  )
  { data, credentials }
}
