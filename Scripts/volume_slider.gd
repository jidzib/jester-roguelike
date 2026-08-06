extends Control

@export var min_value : int = 0
@export var max_value : int = 100

@export var line_edit : LineEdit
@export var vol_slider : HSlider

func _ready() -> void:
	connect_signals()
	initialize()
	
func _exit_tree() -> void:
	disconnect_signals()

func initialize() -> void:
	vol_slider.min_value = min_value
	vol_slider.max_value = max_value
	vol_slider.value = 100
	line_edit.text = str(100)
	
func filter_characters(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var unicode : int = event.unicode
		if unicode != 0:
			var character := char(unicode)
			if !character.is_valid_int():
				line_edit.accept_event()

func normalize_input(toggled_on: bool) -> void:
	if toggled_on:
		return
	var unhandled_value : int = int(line_edit.text)
	unhandled_value = max(min_value, unhandled_value)
	unhandled_value = min(max_value, unhandled_value)
	update_value(unhandled_value)

func update_value(value: int) -> void:
	update_slider(value)
	update_line_edit(value)
	AudioManager.volume = float(value) / 100.0
	AudioManager.set_db()
	
func update_slider(value: float) -> void:
	vol_slider.value = value
	
func update_line_edit(value: float) -> void:
	line_edit.text = str(int(value))

func connect_signals() -> void:
	line_edit.gui_input.connect(filter_characters)
	line_edit.editing_toggled.connect(normalize_input)
	vol_slider.value_changed.connect(update_value)
func disconnect_signals() -> void:
	line_edit.gui_input.disconnect(filter_characters)
	line_edit.editing_toggled.disconnect(normalize_input)
	vol_slider.value_changed.disconnect(update_line_edit)
