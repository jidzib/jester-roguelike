@tool
class_name CustomButton extends TextureButton

@export var label : Label

@export var text : String :
	set(value):
		text = value
		if label:
			label.text = value

@export var font_size : int = 50:
	set(value):
		font_size = value
		label.add_theme_font_size_override("font_size", value)
		
@export var font_color : Color :
	set(value):
		font_color = value
		label.add_theme_color_override("font_color", value)


@export var click_sound : AudioManager.SOUNDS = AudioManager.SOUNDS.BUTTON_CLICK

func _ready() -> void:
	initialize()
	
#func _exit_tree() -> void:
	#disconnect_signals()

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	pressed.connect(play_sound)
	mouse_entered.connect(PlayerCursor.increment_hover_count)
	mouse_exited.connect(PlayerCursor.decrement_hover_count)
func disconnect_signals() -> void:
	pressed.disconnect(play_sound)
	mouse_entered.disconnect(PlayerCursor.increment_hover_count)
	mouse_exited.disconnect(PlayerCursor.decrement_hover_count)
	
func play_sound() -> void:
	print("playing sound")
	print("volume: ", AudioManager.volume)
	print("db: ", AudioManager.db)
	AudioManager.play_randomized_sound_id(click_sound)
	
