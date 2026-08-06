class_name SettingsData extends Resource

@export var volume : int

@export var keybinds : Dictionary[String, InputEvent] = {}


func set_default_settings() -> void:
	volume = 50
	InputMap.load_from_project_settings()
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):
			continue
		keybinds[action] = InputMap.action_get_events(action)[0]
		
func set_key(action_name: String) -> void:
	var new_key : InputEventKey
	
