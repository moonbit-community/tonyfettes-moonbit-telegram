///|
pub struct ChecklistTask {
  id : Int
  text : String
  is_done : Bool
} derive(Show, Eq)

///|
pub fn ChecklistTask::new(
  id~ : Int,
  text~ : String,
  is_done~ : Bool,
) -> ChecklistTask {
  { id, text, is_done }
}

///|
pub impl @json.ToJson for ChecklistTask with to_json(self) {
  let object : Map[String, Json] = {
    "id": @json.to_json(self.id),
    "text": @json.to_json(self.text),
    "is_done": @json.to_json(self.is_done),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChecklistTask with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChecklistTask")
  }
  let id : Int = @json.from_json(object["id"], path~)
  let text : String = @json.from_json(object["text"], path~)
  let is_done : Bool = @json.from_json(object["is_done"], path~)
  { id, text, is_done }
}

///|
pub struct Checklist {
  header : String
  tasks : Array[ChecklistTask]
} derive(Show, Eq)

///|
pub fn Checklist::new(
  header~ : String,
  tasks~ : Array[ChecklistTask],
) -> Checklist {
  { header, tasks }
}

///|
pub impl @json.ToJson for Checklist with to_json(self) {
  let object : Map[String, Json] = {
    "header": @json.to_json(self.header),
    "tasks": @json.to_json(self.tasks),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for Checklist with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for Checklist")
  }
  let header : String = @json.from_json(object["header"], path~)
  let tasks : Array[ChecklistTask] = @json.from_json(object["tasks"], path~)
  { header, tasks }
}

///|
pub struct InputChecklistTask {
  text : String
} derive(Show, Eq)

///|
pub fn InputChecklistTask::new(text~ : String) -> InputChecklistTask {
  { text }
}

///|
pub impl @json.ToJson for InputChecklistTask with to_json(self) {
  let object : Map[String, Json] = { "text": @json.to_json(self.text) }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InputChecklistTask with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for InputChecklistTask")
  }
  let text : String = @json.from_json(object["text"], path~)
  { text }
}

///|
pub struct InputChecklist {
  header : String
  tasks : Array[InputChecklistTask]
} derive(Show, Eq)

///|
pub fn InputChecklist::new(
  header~ : String,
  tasks~ : Array[InputChecklistTask],
) -> InputChecklist {
  { header, tasks }
}

///|
pub impl @json.ToJson for InputChecklist with to_json(self) {
  let object : Map[String, Json] = {
    "header": @json.to_json(self.header),
    "tasks": @json.to_json(self.tasks),
  }
  @json.to_json(object)
}

///|
pub impl @json.FromJson for InputChecklist with from_json(json, path) {
  guard json is Object(object) else {
    raise @json.JsonDecodeError(path~, "Expected object for InputChecklist")
  }
  let header : String = @json.from_json(object["header"], path~)
  let tasks : Array[InputChecklistTask] = @json.from_json(
    object["tasks"],
    path~,
  )
  { header, tasks }
}

///|
pub struct ChecklistTasksDone {} derive(Show, Eq)

///|
pub fn ChecklistTasksDone::new() -> ChecklistTasksDone {
  ChecklistTasksDone::{  }
}

///|
pub impl @json.ToJson for ChecklistTasksDone with to_json(_self) {
  let object : Map[String, Json] = {}
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChecklistTasksDone with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChecklistTasksDone")
  }
  ChecklistTasksDone::{  }
}

///|
pub struct ChecklistTasksAdded {} derive(Show, Eq)

///|
pub fn ChecklistTasksAdded::new() -> ChecklistTasksAdded {
  ChecklistTasksAdded::{  }
}

///|
pub impl @json.ToJson for ChecklistTasksAdded with to_json(_self) {
  let object : Map[String, Json] = {}
  @json.to_json(object)
}

///|
pub impl @json.FromJson for ChecklistTasksAdded with from_json(json, path) {
  guard json is Object(_) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ChecklistTasksAdded",
    )
  }
  ChecklistTasksAdded::{  }
}
