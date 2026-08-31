class_name UIManager extends Node

enum UIs {
	MAIN_MENU,
	LOOT_SCREEN,
	GAME_OVER,
	SETTINGS,
	PAUSE_MENU
}

var UI_SCENES : Dictionary[UIs, PackedScene] = {
	UIs.MAIN_MENU : load("uid://cesjacpgcskw6"),
	UIs.LOOT_SCREEN : load("uid://h1urf3ntfase"),
	UIs.GAME_OVER : load("uid://1qfrflwr5ytv"),
	UIs.SETTINGS : load("uid://bhepxlot6h21d"),
	UIs.PAUSE_MENU : load("uid://bghc4k808r5h7")
}

var ui_stack : Array[UI] = []

func _ready() -> void:
	print("~~~~~[INITIALIZE ACTION]~~~~~")
	print("Initializing UIManager")
	add_ui(UI_SCENES[UIs.MAIN_MENU].instantiate())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_menu"):
		if not ui_stack:
			add_ui(UI_SCENES[UIs.PAUSE_MENU].instantiate())
		else:
			if ui_stack[-1].is_menu:
				remove_ui()

func add_ui(ui: UI) -> void:
	ui.layer += ui_stack.size()
	ui_stack.append(ui)
	print("~~~~~[ADD ACTION]~~~~~")
	print("Added UI: ", ui, " to stack")
	print("Stack state: ", ui_stack)
	add_child(ui)
	
func remove_ui() -> void:
	print("~~~~~[REMOVE ACTION]~~~~~")
	print("Attemping to remove top UI from stack")
	print(ui_stack)
	if ui_stack:
		var ui_to_remove : UI = ui_stack.pop_back()
		print("Removing ", ui_to_remove, " from stack")
		ui_to_remove.close()
		ui_to_remove.queue_free()
		print("Stack state: ", ui_stack)
	else:
		print("Stack is empty, nothing to remove")
		
func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false
