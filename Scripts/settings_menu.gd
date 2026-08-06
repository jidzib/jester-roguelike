class_name Settings extends UI

static var SETTINGS_SAVE_PATH : String = "res://Resources/SaveData/settings_data.tres"
@export var container : VBoxContainer
@export var save_button : TextureButton
@export var volume : Control

enum ACTIONS {
	MOVE_UP,
	MOVE_DOWN,
	MOVE_LEFT,
	MOVE_RIGHT,
	ROLL,
	ITEM_USE
}

func _ready() -> void:
	load_settings()
	initialize_keybinds()
	save_button.pressed.connect(save_settings)
	
func initialize_keybinds() -> void:
	for child in container.get_children():
		if child.name.begins_with("KB_"):
			child.update_keycode_string()
			
func initialize_settings() -> void:
	var settings_data : SettingsData = SettingsData.new()
	settings_data.set_default_settings()
	ResourceSaver.save(settings_data, SETTINGS_SAVE_PATH)
	
func save_settings() -> void:
	var settings_data : SettingsData = SettingsData.new()
	settings_data.volume = int(volume.vol_slider.value)
	for key in ACTIONS:
		var action_name : String = str(key)
		var event : InputEvent = InputMap.action_get_events(action_name)[0]
		settings_data.keybinds[action_name] = event
	ResourceSaver.save(settings_data, SETTINGS_SAVE_PATH)
	
func load_settings() -> void:
	if not ResourceLoader.exists(SETTINGS_SAVE_PATH):
		initialize_settings()
	var save_data : SettingsData = ResourceLoader.load(SETTINGS_SAVE_PATH)
	volume.update_value(save_data.volume)
	for action in save_data.keybinds:
		rebind_key(action, save_data.keybinds[action])
	
static func rebind_key(_action_name: String, new_key: InputEvent) -> void:
	InputMap.action_erase_events(_action_name)
	if new_key is InputEventKey:
		var new_event : InputEventKey = InputEventKey.new() # KEYBOARD
		new_event.physical_keycode = new_key.physical_keycode
		InputMap.action_add_event(_action_name, new_event)
	elif new_key is InputEventMouseButton:
		var new_event : InputEventMouseButton = InputEventMouseButton.new() # MOUSE
		new_event.button_index = new_key.button_index
		InputMap.action_add_event(_action_name, new_event)
