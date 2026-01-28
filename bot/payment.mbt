///|
pub struct Invoice {
  title : String
  description : String
  start_parameter : String
  currency : String
  total_amount : Int
} derive(Show, Eq)

///|
pub fn Invoice::new(
  title~ : String,
  description~ : String,
  start_parameter~ : String,
  currency~ : String,
  total_amount~ : Int,
) -> Invoice {
  { title, description, start_parameter, currency, total_amount }
}

///|
pub impl @json.ToJson for Invoice with to_json(self) {
  let object : Map[String, Json] = {
    "title": @json.to_json(self.title),
    "description": @json.to_json(self.description),
    "start_parameter": @json.to_json(self.start_parameter),
    "currency": @json.to_json(self.currency),
    "total_amount": @json.to_json(self.total_amount),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Invoice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Invoice")
  }
  let title : String = @json.from_json(object["title"], path~)
  let description : String = @json.from_json(object["description"], path~)
  let start_parameter : String = @json.from_json(object["start_parameter"], path~)
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  { title, description, start_parameter, currency, total_amount }
}

///|
pub struct LabeledPrice {
  label : String
  amount : Int
} derive(Show, Eq)

///|
pub fn LabeledPrice::new(label~ : String, amount~ : Int) -> LabeledPrice {
  { label, amount }
}

///|
pub impl @json.ToJson for LabeledPrice with to_json(self) {
  let object : Map[String, Json] = {
    "label": @json.to_json(self.label),
    "amount": @json.to_json(self.amount),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for LabeledPrice with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for LabeledPrice")
  }
  let label : String = @json.from_json(object["label"], path~)
  let amount : Int = @json.from_json(object["amount"], path~)
  { label, amount }
}

///|
pub struct ShippingAddress {
  country_code : String
  state : String
  city : String
  street_line1 : String
  street_line2 : String
  post_code : String
} derive(Show, Eq)

///|
pub fn ShippingAddress::new(
  country_code~ : String,
  state~ : String,
  city~ : String,
  street_line1~ : String,
  street_line2~ : String,
  post_code~ : String,
) -> ShippingAddress {
  { country_code, state, city, street_line1, street_line2, post_code }
}

///|
pub impl @json.ToJson for ShippingAddress with to_json(self) {
  let object : Map[String, Json] = {
    "country_code": @json.to_json(self.country_code),
    "state": @json.to_json(self.state),
    "city": @json.to_json(self.city),
    "street_line1": @json.to_json(self.street_line1),
    "street_line2": @json.to_json(self.street_line2),
    "post_code": @json.to_json(self.post_code),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ShippingAddress with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ShippingAddress")
  }
  let country_code : String = @json.from_json(object["country_code"], path~)
  let state : String = @json.from_json(object["state"], path~)
  let city : String = @json.from_json(object["city"], path~)
  let street_line1 : String = @json.from_json(object["street_line1"], path~)
  let street_line2 : String = @json.from_json(object["street_line2"], path~)
  let post_code : String = @json.from_json(object["post_code"], path~)
  { country_code, state, city, street_line1, street_line2, post_code }
}

///|
pub struct OrderInfo {
  name : String?
  phone_number : String?
  email : String?
  shipping_address : ShippingAddress?
} derive(Show, Eq)

///|
pub fn OrderInfo::new(
  name? : String,
  phone_number? : String,
  email? : String,
  shipping_address? : ShippingAddress,
) -> OrderInfo {
  { name, phone_number, email, shipping_address }
}

///|
pub impl @json.ToJson for OrderInfo with to_json(self) {
  let object : Map[String, Json] = {}
  if self.name is Some(v) {
    object["name"] = @json.to_json(v)
  }
  if self.phone_number is Some(v) {
    object["phone_number"] = @json.to_json(v)
  }
  if self.email is Some(v) {
    object["email"] = @json.to_json(v)
  }
  if self.shipping_address is Some(v) {
    object["shipping_address"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for OrderInfo with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for OrderInfo")
  }
  let name : String? = if object.get("name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let phone_number : String? = if object.get("phone_number") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let email : String? = if object.get("email") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let shipping_address : ShippingAddress? = if object.get("shipping_address")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { name, phone_number, email, shipping_address }
}

///|
pub struct ShippingOption {
  id : String
  title : String
  prices : Array[LabeledPrice]
} derive(Show, Eq)

///|
pub fn ShippingOption::new(
  id~ : String,
  title~ : String,
  prices~ : Array[LabeledPrice],
) -> ShippingOption {
  { id, title, prices }
}

///|
pub impl @json.ToJson for ShippingOption with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "title": @json.to_json(self.title),
    "prices": @json.to_json(self.prices),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ShippingOption with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ShippingOption")
  }
  let id : String = @json.from_json(object["id"], path~)
  let title : String = @json.from_json(object["title"], path~)
  let prices : Array[LabeledPrice] = @json.from_json(object["prices"], path~)
  { id, title, prices }
}

///|
pub struct SuccessfulPayment {
  currency : String
  total_amount : Int
  invoice_payload : String
  shipping_option_id : String?
  order_info : OrderInfo?
  telegram_payment_charge_id : String
  provider_payment_charge_id : String
} derive(Show, Eq)

///|
pub fn SuccessfulPayment::new(
  currency~ : String,
  total_amount~ : Int,
  invoice_payload~ : String,
  shipping_option_id? : String,
  order_info? : OrderInfo,
  telegram_payment_charge_id~ : String,
  provider_payment_charge_id~ : String,
) -> SuccessfulPayment {
  {
    currency,
    total_amount,
    invoice_payload,
    shipping_option_id,
    order_info,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
pub impl @json.ToJson for SuccessfulPayment with to_json(self) {
  let object : Map[String, Json] = {
    "currency": @json.to_json(self.currency),
    "total_amount": @json.to_json(self.total_amount),
    "invoice_payload": @json.to_json(self.invoice_payload),
    "telegram_payment_charge_id": @json.to_json(self.telegram_payment_charge_id),
    "provider_payment_charge_id": @json.to_json(self.provider_payment_charge_id),
  }
  if self.shipping_option_id is Some(v) {
    object["shipping_option_id"] = @json.to_json(v)
  }
  if self.order_info is Some(v) {
    object["order_info"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for SuccessfulPayment with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for SuccessfulPayment")
  }
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  let invoice_payload : String = @json.from_json(object["invoice_payload"], path~)
  let shipping_option_id : String? = if object.get("shipping_option_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let order_info : OrderInfo? = if object.get("order_info") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let telegram_payment_charge_id : String = @json.from_json(
    object["telegram_payment_charge_id"],
    path~,
  )
  let provider_payment_charge_id : String = @json.from_json(
    object["provider_payment_charge_id"],
    path~,
  )
  {
    currency,
    total_amount,
    invoice_payload,
    shipping_option_id,
    order_info,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
pub struct RefundedPayment {
  currency : String
  total_amount : Int
  invoice_payload : String
  telegram_payment_charge_id : String
  provider_payment_charge_id : String?
} derive(Show, Eq)

///|
pub fn RefundedPayment::new(
  currency~ : String,
  total_amount~ : Int,
  invoice_payload~ : String,
  telegram_payment_charge_id~ : String,
  provider_payment_charge_id? : String,
) -> RefundedPayment {
  {
    currency,
    total_amount,
    invoice_payload,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}

///|
pub impl @json.ToJson for RefundedPayment with to_json(self) {
  let object : Map[String, Json] = {
    "currency": @json.to_json(self.currency),
    "total_amount": @json.to_json(self.total_amount),
    "invoice_payload": @json.to_json(self.invoice_payload),
    "telegram_payment_charge_id": @json.to_json(self.telegram_payment_charge_id),
  }
  if self.provider_payment_charge_id is Some(v) {
    object["provider_payment_charge_id"] = @json.to_json(v)
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for RefundedPayment with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for RefundedPayment")
  }
  let currency : String = @json.from_json(object["currency"], path~)
  let total_amount : Int = @json.from_json(object["total_amount"], path~)
  let invoice_payload : String = @json.from_json(object["invoice_payload"], path~)
  let telegram_payment_charge_id : String = @json.from_json(
    object["telegram_payment_charge_id"],
    path~,
  )
  let provider_payment_charge_id : String? = if object.get(
      "provider_payment_charge_id",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    currency,
    total_amount,
    invoice_payload,
    telegram_payment_charge_id,
    provider_payment_charge_id,
  }
}
