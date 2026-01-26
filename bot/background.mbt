///|
/// Placeholder for Document until it's implemented
pub struct DocumentPlaceholder {
  file_id : String
  file_unique_id : String
} derive(Show, Eq)

///|
pub fn DocumentPlaceholder::new(
  file_id~ : String,
  file_unique_id~ : String,
) -> DocumentPlaceholder {
  { file_id, file_unique_id }
}

///|
pub impl @json.ToJson for DocumentPlaceholder with to_json(self) {
  let obj : Map[String, Json] = {
    "file_id": @json.to_json(self.file_id),
    "file_unique_id": @json.to_json(self.file_unique_id),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for DocumentPlaceholder with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for DocumentPlaceholder",
    )
  }
  let file_id : String = @json.from_json(obj["file_id"], path~)
  let file_unique_id : String = @json.from_json(obj["file_unique_id"], path~)
  { file_id, file_unique_id }
}

///|
pub struct BackgroundFillSolid {
  color : Int
} derive(Show, Eq)

///|
pub fn BackgroundFillSolid::new(color~ : Int) -> BackgroundFillSolid {
  { color, }
}

///|
pub struct BackgroundFillGradient {
  top_color : Int
  bottom_color : Int
  rotation_angle : Int
} derive(Show, Eq)

///|
pub fn BackgroundFillGradient::new(
  top_color~ : Int,
  bottom_color~ : Int,
  rotation_angle~ : Int,
) -> BackgroundFillGradient {
  { top_color, bottom_color, rotation_angle }
}

///|
pub struct BackgroundFillFreeformGradient {
  colors : Array[Int]
} derive(Show, Eq)

///|
pub fn BackgroundFillFreeformGradient::new(
  colors~ : Array[Int],
) -> BackgroundFillFreeformGradient {
  { colors, }
}

///|
pub(all) enum BackgroundFill {
  Solid(BackgroundFillSolid)
  Gradient(BackgroundFillGradient)
  FreeformGradient(BackgroundFillFreeformGradient)
} derive(Show, Eq)

///|
pub impl @json.ToJson for BackgroundFill with to_json(self) {
  match self {
    Solid(v) => {
      let obj : Map[String, Json] = {
        "type": "solid",
        "color": @json.to_json(v.color),
      }
      @json.to_json(obj)
    }
    Gradient(v) => {
      let obj : Map[String, Json] = {
        "type": "gradient",
        "top_color": @json.to_json(v.top_color),
        "bottom_color": @json.to_json(v.bottom_color),
        "rotation_angle": @json.to_json(v.rotation_angle),
      }
      @json.to_json(obj)
    }
    FreeformGradient(v) => {
      let obj : Map[String, Json] = {
        "type": "freeform_gradient",
        "colors": @json.to_json(v.colors),
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for BackgroundFill with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for BackgroundFill")
  }
  guard obj["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field for BackgroundFill")
  }
  match type_ {
    "solid" => {
      let color : Int = @json.from_json(obj["color"], path~)
      Solid({ color, })
    }
    "gradient" => {
      let top_color : Int = @json.from_json(obj["top_color"], path~)
      let bottom_color : Int = @json.from_json(obj["bottom_color"], path~)
      let rotation_angle : Int = @json.from_json(obj["rotation_angle"], path~)
      Gradient({ top_color, bottom_color, rotation_angle })
    }
    "freeform_gradient" => {
      let colors : Array[Int] = @json.from_json(obj["colors"], path~)
      FreeformGradient({ colors, })
    }
    _ =>
      raise @json.JsonDecodeError(
        path~,
        "Unknown type for BackgroundFill: \{type_}",
      )
  }
}

///|
pub struct BackgroundTypeFill {
  fill : BackgroundFill
  dark_theme_dimming : Int
} derive(Show, Eq)

///|
pub fn BackgroundTypeFill::new(
  fill~ : BackgroundFill,
  dark_theme_dimming~ : Int,
) -> BackgroundTypeFill {
  { fill, dark_theme_dimming }
}

///|
pub struct BackgroundTypeWallpaper {
  document : DocumentPlaceholder
  dark_theme_dimming : Int
  is_blurred : Bool?
  is_moving : Bool?
} derive(Show, Eq)

///|
pub fn BackgroundTypeWallpaper::new(
  document~ : DocumentPlaceholder,
  dark_theme_dimming~ : Int,
  is_blurred? : Bool,
  is_moving? : Bool,
) -> BackgroundTypeWallpaper {
  { document, dark_theme_dimming, is_blurred, is_moving }
}

///|
pub struct BackgroundTypePattern {
  document : DocumentPlaceholder
  fill : BackgroundFill
  intensity : Int
  is_inverted : Bool?
  is_moving : Bool?
} derive(Show, Eq)

///|
pub fn BackgroundTypePattern::new(
  document~ : DocumentPlaceholder,
  fill~ : BackgroundFill,
  intensity~ : Int,
  is_inverted? : Bool,
  is_moving? : Bool,
) -> BackgroundTypePattern {
  { document, fill, intensity, is_inverted, is_moving }
}

///|
pub struct BackgroundTypeChatTheme {
  theme_name : String
} derive(Show, Eq)

///|
pub fn BackgroundTypeChatTheme::new(
  theme_name~ : String,
) -> BackgroundTypeChatTheme {
  { theme_name, }
}

///|
pub(all) enum BackgroundType {
  Fill(BackgroundTypeFill)
  Wallpaper(BackgroundTypeWallpaper)
  Pattern(BackgroundTypePattern)
  ChatTheme(BackgroundTypeChatTheme)
} derive(Show, Eq)

///|
pub impl @json.ToJson for BackgroundType with to_json(self) {
  match self {
    Fill(v) => {
      let obj : Map[String, Json] = {
        "type": "fill",
        "fill": @json.to_json(v.fill),
        "dark_theme_dimming": @json.to_json(v.dark_theme_dimming),
      }
      @json.to_json(obj)
    }
    Wallpaper(v) => {
      let obj : Map[String, Json] = {
        "type": "wallpaper",
        "document": @json.to_json(v.document),
        "dark_theme_dimming": @json.to_json(v.dark_theme_dimming),
      }
      if v.is_blurred is Some(b) {
        obj["is_blurred"] = @json.to_json(b)
      }
      if v.is_moving is Some(m) {
        obj["is_moving"] = @json.to_json(m)
      }
      @json.to_json(obj)
    }
    Pattern(v) => {
      let obj : Map[String, Json] = {
        "type": "pattern",
        "document": @json.to_json(v.document),
        "fill": @json.to_json(v.fill),
        "intensity": @json.to_json(v.intensity),
      }
      if v.is_inverted is Some(i) {
        obj["is_inverted"] = @json.to_json(i)
      }
      if v.is_moving is Some(m) {
        obj["is_moving"] = @json.to_json(m)
      }
      @json.to_json(obj)
    }
    ChatTheme(v) => {
      let obj : Map[String, Json] = {
        "type": "chat_theme",
        "theme_name": @json.to_json(v.theme_name),
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for BackgroundType with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for BackgroundType")
  }
  guard obj["type"] is String(type_) else {
    raise @json.JsonDecodeError(path~, "Expected type field for BackgroundType")
  }
  match type_ {
    "fill" => {
      let fill : BackgroundFill = @json.from_json(obj["fill"], path~)
      let dark_theme_dimming : Int = @json.from_json(
        obj["dark_theme_dimming"],
        path~,
      )
      Fill({ fill, dark_theme_dimming })
    }
    "wallpaper" => {
      let document : DocumentPlaceholder = @json.from_json(
        obj["document"],
        path~,
      )
      let dark_theme_dimming : Int = @json.from_json(
        obj["dark_theme_dimming"],
        path~,
      )
      let is_blurred : Bool? = if obj.get("is_blurred") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let is_moving : Bool? = if obj.get("is_moving") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Wallpaper({ document, dark_theme_dimming, is_blurred, is_moving })
    }
    "pattern" => {
      let document : DocumentPlaceholder = @json.from_json(
        obj["document"],
        path~,
      )
      let fill : BackgroundFill = @json.from_json(obj["fill"], path~)
      let intensity : Int = @json.from_json(obj["intensity"], path~)
      let is_inverted : Bool? = if obj.get("is_inverted") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let is_moving : Bool? = if obj.get("is_moving") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Pattern({ document, fill, intensity, is_inverted, is_moving })
    }
    "chat_theme" => {
      let theme_name : String = @json.from_json(obj["theme_name"], path~)
      ChatTheme({ theme_name, })
    }
    _ =>
      raise @json.JsonDecodeError(
        path~,
        "Unknown type for BackgroundType: \{type_}",
      )
  }
}

///|
pub struct ChatBackground {
  type_ : BackgroundType
} derive(Show, Eq)

///|
pub fn ChatBackground::new(type_~ : BackgroundType) -> ChatBackground {
  { type_, }
}

///|
pub impl @json.ToJson for ChatBackground with to_json(self) {
  let obj : Map[String, Json] = { "type": @json.to_json(self.type_) }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatBackground with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatBackground")
  }
  let type_ : BackgroundType = @json.from_json(obj["type"], path~)
  { type_, }
}
