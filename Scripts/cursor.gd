class_name PlayerCursor extends Node


static var hover_count : int = 0 :
	set(value):
		hover_count = value
		update_cursor()
		
enum CURSOR_MODES {
	DEFAULT,
	HOVERING
}

static var cursors : Dictionary[CURSOR_MODES, Texture] = {
	CURSOR_MODES.DEFAULT : preload("uid://c0dr8mlp8dd8w"),
	CURSOR_MODES.HOVERING : preload("uid://dvfn3edkg54u5")
}

static var current_cursor : CURSOR_MODES = CURSOR_MODES.DEFAULT
static func set_cursor(cursor: CURSOR_MODES) -> void:
	current_cursor = cursor
	Input.set_custom_mouse_cursor(cursors[cursor])
	
static func update_cursor() -> void:
	if hover_count > 0:
		set_cursor(CURSOR_MODES.HOVERING)
	else:
		set_cursor(CURSOR_MODES.DEFAULT)

static func increment_hover_count() -> void:
	hover_count += 1
static func decrement_hover_count() -> void:
	hover_count -= 1
