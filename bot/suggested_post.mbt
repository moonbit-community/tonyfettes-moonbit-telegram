///|
/// Parameters for suggested posts
pub struct SuggestedPostParameters {
  text : String?
  link_preview_options : LinkPreviewOptions?
  is_disabled : Bool?
} derive(Show, Eq)

///|
pub fn SuggestedPostParameters::new(
  text? : String,
  link_preview_options? : LinkPreviewOptions,
  is_disabled? : Bool,
) -> SuggestedPostParameters {
  { text, link_preview_options, is_disabled }
}

///|
pub impl @json.ToJson for SuggestedPostParameters with to_json(self) {
  let object : Map[String, Json] = {}
  if self.text is Some(v) {
    object["text"] = @json.to_json(v)
  }
  if self.link_preview_options is Some(v) {
    object["link_preview_options"] = @json.to_json(v)
  }
  if self.is_disabled is Some(v) {
    object["is_disabled"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostParameters with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostParameters")
  }
  let text : String? = if object.get("text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewOptions? = if object.get(
    "link_preview_options",
  ) is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_disabled : Bool? = if object.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { text, link_preview_options, is_disabled }
}

///|
/// Information about a suggested post
pub struct SuggestedPostInfo {
  suggested_post_parameters : SuggestedPostParameters?
  is_approved : Bool
  is_declined : Bool
  is_paid : Bool
} derive(Show, Eq)

///|
pub fn SuggestedPostInfo::new(
  suggested_post_parameters? : SuggestedPostParameters,
  is_approved~ : Bool,
  is_declined~ : Bool,
  is_paid~ : Bool,
) -> SuggestedPostInfo {
  { suggested_post_parameters, is_approved, is_declined, is_paid }
}

///|
pub impl @json.ToJson for SuggestedPostInfo with to_json(self) {
  let object : Map[String, Json] = {
    "is_approved": @json.to_json(self.is_approved),
    "is_declined": @json.to_json(self.is_declined),
    "is_paid": @json.to_json(self.is_paid),
  }
  if self.suggested_post_parameters is Some(v) {
    object["suggested_post_parameters"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostInfo")
  }
  let suggested_post_parameters : SuggestedPostParameters? = if object.get(
    "suggested_post_parameters",
  ) is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let is_approved : Bool = @json.from_json(object["is_approved"], path~)
  let is_declined : Bool = @json.from_json(object["is_declined"], path~)
  let is_paid : Bool = @json.from_json(object["is_paid"], path~)
  { suggested_post_parameters, is_approved, is_declined, is_paid }
}

///|
/// Price of a suggested post
pub struct SuggestedPostPrice {
  star_count : Int
} derive(Show, Eq)

///|
pub fn SuggestedPostPrice::new(star_count~ : Int) -> SuggestedPostPrice {
  { star_count, }
}

///|
pub impl @json.ToJson for SuggestedPostPrice with to_json(self) {
  let object : Map[String, Json] = { "star_count": @json.to_json(self.star_count) }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostPrice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostPrice")
  }
  let star_count : Int = @json.from_json(object["star_count"], path~)
  { star_count, }
}

///|
/// Service message: A suggested post was approved
pub struct SuggestedPostApproved {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
pub fn SuggestedPostApproved::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostApproved {
  { user, suggested_post_info }
}

///|
pub impl @json.ToJson for SuggestedPostApproved with to_json(self) {
  let object : Map[String, Json] = {
    "user": @json.to_json(self.user),
    "suggested_post_info": @json.to_json(self.suggested_post_info),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostApproved with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostApproved")
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Service message: A suggested post was declined
pub struct SuggestedPostDeclined {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
pub fn SuggestedPostDeclined::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostDeclined {
  { user, suggested_post_info }
}

///|
pub impl @json.ToJson for SuggestedPostDeclined with to_json(self) {
  let object : Map[String, Json] = {
    "user": @json.to_json(self.user),
    "suggested_post_info": @json.to_json(self.suggested_post_info),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostDeclined with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostDeclined")
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Service message: A suggested post was paid
pub struct SuggestedPostPaid {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
pub fn SuggestedPostPaid::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostPaid {
  { user, suggested_post_info }
}

///|
pub impl @json.ToJson for SuggestedPostPaid with to_json(self) {
  let object : Map[String, Json] = {
    "user": @json.to_json(self.user),
    "suggested_post_info": @json.to_json(self.suggested_post_info),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostPaid with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuggestedPostPaid")
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}

///|
/// Service message: Suggested post approval failed
pub struct SuggestedPostApprovalFailed {
  user : User
  suggested_post_info : SuggestedPostInfo
} derive(Show, Eq)

///|
pub fn SuggestedPostApprovalFailed::new(
  user~ : User,
  suggested_post_info~ : SuggestedPostInfo,
) -> SuggestedPostApprovalFailed {
  { user, suggested_post_info }
}

///|
pub impl @json.ToJson for SuggestedPostApprovalFailed with to_json(self) {
  let object : Map[String, Json] = {
    "user": @json.to_json(self.user),
    "suggested_post_info": @json.to_json(self.suggested_post_info),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuggestedPostApprovalFailed with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for SuggestedPostApprovalFailed",
    )
  }
  let user : User = @json.from_json(object["user"], path~)
  let suggested_post_info : SuggestedPostInfo = @json.from_json(
    object["suggested_post_info"],
    path~,
  )
  { user, suggested_post_info }
}
