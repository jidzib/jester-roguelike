class_name CustomButton extends TextureButton

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
	
