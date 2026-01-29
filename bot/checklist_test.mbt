///|
test "ChecklistTask JSON round-trip" {
  let object = ChecklistTask::new(id=1, text="Task 1", is_done=false)
  let json = @json.to_json(object)
  let parsed : ChecklistTask = @json.from_json(json)
  inspect(parsed.id, content="1")
  inspect(parsed.text, content="Task 1")
  inspect(parsed.is_done, content="false")
}

///|
test "Checklist JSON round-trip" {
  let task1 = ChecklistTask::new(id=1, text="Task 1", is_done=true)
  let task2 = ChecklistTask::new(id=2, text="Task 2", is_done=false)
  let object = Checklist::new(header="Shopping List", tasks=[task1, task2])
  let json = @json.to_json(object)
  let parsed : Checklist = @json.from_json(json)
  inspect(parsed.header, content="Shopping List")
  inspect(parsed.tasks.length(), content="2")
  inspect(parsed.tasks[0].text, content="Task 1")
  inspect(parsed.tasks[0].is_done, content="true")
  inspect(parsed.tasks[1].text, content="Task 2")
  inspect(parsed.tasks[1].is_done, content="false")
}

///|
test "InputChecklistTask JSON round-trip" {
  let object = InputChecklistTask::new(text="New Task")
  let json = @json.to_json(object)
  let parsed : InputChecklistTask = @json.from_json(json)
  inspect(parsed.text, content="New Task")
}

///|
test "InputChecklist JSON round-trip" {
  let task1 = InputChecklistTask::new(text="Buy milk")
  let task2 = InputChecklistTask::new(text="Buy eggs")
  let object = InputChecklist::new(header="Groceries", tasks=[task1, task2])
  let json = @json.to_json(object)
  let parsed : InputChecklist = @json.from_json(json)
  inspect(parsed.header, content="Groceries")
  inspect(parsed.tasks.length(), content="2")
  inspect(parsed.tasks[0].text, content="Buy milk")
  inspect(parsed.tasks[1].text, content="Buy eggs")
}

///|
test "ChecklistTasksDone JSON round-trip" {
  let object = ChecklistTasksDone::new()
  let json = @json.to_json(object)
  let _parsed : ChecklistTasksDone = @json.from_json(json)

}

///|
test "ChecklistTasksAdded JSON round-trip" {
  let object = ChecklistTasksAdded::new()
  let json = @json.to_json(object)
  let _parsed : ChecklistTasksAdded = @json.from_json(json)

}
