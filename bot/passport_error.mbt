///|
pub struct PassportElementErrorDataField {
  type_ : String
  field_name : String
  data_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorDataField::new(
  type_~ : String,
  field_name~ : String,
  data_hash~ : String,
  message~ : String,
) -> PassportElementErrorDataField {
  { type_, field_name, data_hash, message }
}

///|
pub struct PassportElementErrorFrontSide {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorFrontSide::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorFrontSide {
  { type_, file_hash, message }
}

///|
pub struct PassportElementErrorReverseSide {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorReverseSide::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorReverseSide {
  { type_, file_hash, message }
}

///|
pub struct PassportElementErrorSelfie {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorSelfie::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorSelfie {
  { type_, file_hash, message }
}

///|
pub struct PassportElementErrorFile {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorFile::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorFile {
  { type_, file_hash, message }
}

///|
pub struct PassportElementErrorFiles {
  type_ : String
  file_hashes : Array[String]
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorFiles::new(
  type_~ : String,
  file_hashes~ : Array[String],
  message~ : String,
) -> PassportElementErrorFiles {
  { type_, file_hashes, message }
}

///|
pub struct PassportElementErrorTranslationFile {
  type_ : String
  file_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorTranslationFile::new(
  type_~ : String,
  file_hash~ : String,
  message~ : String,
) -> PassportElementErrorTranslationFile {
  { type_, file_hash, message }
}

///|
pub struct PassportElementErrorTranslationFiles {
  type_ : String
  file_hashes : Array[String]
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorTranslationFiles::new(
  type_~ : String,
  file_hashes~ : Array[String],
  message~ : String,
) -> PassportElementErrorTranslationFiles {
  { type_, file_hashes, message }
}

///|
pub struct PassportElementErrorUnspecified {
  type_ : String
  element_hash : String
  message : String
} derive(Show, Eq)

///|
pub fn PassportElementErrorUnspecified::new(
  type_~ : String,
  element_hash~ : String,
  message~ : String,
) -> PassportElementErrorUnspecified {
  { type_, element_hash, message }
}

///|
pub(all) enum PassportElementError {
  DataField(PassportElementErrorDataField)
  FrontSide(PassportElementErrorFrontSide)
  ReverseSide(PassportElementErrorReverseSide)
  Selfie(PassportElementErrorSelfie)
  File(PassportElementErrorFile)
  Files(PassportElementErrorFiles)
  TranslationFile(PassportElementErrorTranslationFile)
  TranslationFiles(PassportElementErrorTranslationFiles)
  Unspecified(PassportElementErrorUnspecified)
} derive(Show, Eq)

///|
pub impl @json.ToJson for PassportElementError with to_json(self) {
  match self {
    DataField(v) => {
      let obj : Map[String, Json] = {
        "source": "data",
        "type": @json.to_json(v.type_),
        "field_name": @json.to_json(v.field_name),
        "data_hash": @json.to_json(v.data_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    FrontSide(v) => {
      let obj : Map[String, Json] = {
        "source": "front_side",
        "type": @json.to_json(v.type_),
        "file_hash": @json.to_json(v.file_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    ReverseSide(v) => {
      let obj : Map[String, Json] = {
        "source": "reverse_side",
        "type": @json.to_json(v.type_),
        "file_hash": @json.to_json(v.file_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    Selfie(v) => {
      let obj : Map[String, Json] = {
        "source": "selfie",
        "type": @json.to_json(v.type_),
        "file_hash": @json.to_json(v.file_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    File(v) => {
      let obj : Map[String, Json] = {
        "source": "file",
        "type": @json.to_json(v.type_),
        "file_hash": @json.to_json(v.file_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    Files(v) => {
      let obj : Map[String, Json] = {
        "source": "files",
        "type": @json.to_json(v.type_),
        "file_hashes": @json.to_json(v.file_hashes),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    TranslationFile(v) => {
      let obj : Map[String, Json] = {
        "source": "translation_file",
        "type": @json.to_json(v.type_),
        "file_hash": @json.to_json(v.file_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    TranslationFiles(v) => {
      let obj : Map[String, Json] = {
        "source": "translation_files",
        "type": @json.to_json(v.type_),
        "file_hashes": @json.to_json(v.file_hashes),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
    Unspecified(v) => {
      let obj : Map[String, Json] = {
        "source": "unspecified",
        "type": @json.to_json(v.type_),
        "element_hash": @json.to_json(v.element_hash),
        "message": @json.to_json(v.message),
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for PassportElementError with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for PassportElementError",
    )
  }
  guard obj["source"] is String(source) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected source field for PassportElementError",
    )
  }
  match source {
    "data" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let field_name : String = @json.from_json(obj["field_name"], path~)
      let data_hash : String = @json.from_json(obj["data_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      DataField({ type_, field_name, data_hash, message })
    }
    "front_side" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hash : String = @json.from_json(obj["file_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      FrontSide({ type_, file_hash, message })
    }
    "reverse_side" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hash : String = @json.from_json(obj["file_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      ReverseSide({ type_, file_hash, message })
    }
    "selfie" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hash : String = @json.from_json(obj["file_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      Selfie({ type_, file_hash, message })
    }
    "file" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hash : String = @json.from_json(obj["file_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      File({ type_, file_hash, message })
    }
    "files" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hashes : Array[String] = @json.from_json(
        obj["file_hashes"],
        path~,
      )
      let message : String = @json.from_json(obj["message"], path~)
      Files({ type_, file_hashes, message })
    }
    "translation_file" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hash : String = @json.from_json(obj["file_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      TranslationFile({ type_, file_hash, message })
    }
    "translation_files" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let file_hashes : Array[String] = @json.from_json(
        obj["file_hashes"],
        path~,
      )
      let message : String = @json.from_json(obj["message"], path~)
      TranslationFiles({ type_, file_hashes, message })
    }
    "unspecified" => {
      let type_ : String = @json.from_json(obj["type"], path~)
      let element_hash : String = @json.from_json(obj["element_hash"], path~)
      let message : String = @json.from_json(obj["message"], path~)
      Unspecified({ type_, element_hash, message })
    }
    _ =>
      raise @json.JsonDecodeError(
        path~,
        "Unknown source for PassportElementError: \{source}",
      )
  }
}
