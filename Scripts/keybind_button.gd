@tool
class_name KeybindButton extends Control

@export var button : CustomButton

@export var action_label : Label
@export var keybind_label : Label

@export var action_name : String
@export var action_id : Settings.ACTIONS :
	set(value):
		action_id = value
		action_name = Settings.ACTIONS.find_key(action_id)
		action_label.text = action_name
		update_keycode_string()

var keycode_string : String :
	set(value):
		keycode_string = value
		keybind_label.text = keycode_string

func update_keycode_string() -> void:
	if not InputMap.has_action(action_name):
		keycode_string = "Action not found"
		return
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey or event is InputEventMouseButton:
			keycode_string = event.as_text()
			return
	keycode_string = ""	

var listening : bool = false

func _unhandled_input(event: InputEvent) -> void:
	if listening:
		if event is InputEventKey or event is InputEventMouseButton:
			Settings.rebind_key(action_name, event)
			update_keycode_string()
			set_listening(false)
		
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func set_listening(is_listening: bool) -> void:
	listening = is_listening
	button.disabled = listening
	if listening:
		keycode_string = "Listening"
	
func _on_button_pressed() -> void:
	set_listening(true)
