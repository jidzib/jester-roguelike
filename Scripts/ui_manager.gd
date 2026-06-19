class_name UIManager extends Node

enum UIs {
	MAIN_MENU,
	LOOT_SCREEN
}

var UI_SCENES : Dictionary[UIs, PackedScene] = {
	UIs.MAIN_MENU : load("uid://cesjacpgcskw6"),
	UIs.LOOT_SCREEN : load("uid://h1urf3ntfase")
}

var current_ui : UI

func _ready() -> void:
	current_ui = UI_SCENES[UIs.MAIN_MENU].instantiate()
	add_child(current_ui)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		resume_game()
		clear_ui()

func switch_ui(ui: UI) -> void:
	clear_ui()
	set_ui(ui)
	
func set_ui(ui_scene : Node) -> void:
	current_ui = ui_scene
	add_child(current_ui)
	
func clear_ui() -> void:
	if current_ui:
		current_ui.close()
		current_ui.queue_free()

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false
