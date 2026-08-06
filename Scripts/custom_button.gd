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
func disconnect_signals() -> void:
	pressed.disconnect(play_sound)
	
func play_sound() -> void:
	print("playing sound")
	AudioManager.play_randomized_sound_id(click_sound)
	
