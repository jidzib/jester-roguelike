@tool
class_name SpriteGroup extends CanvasGroup

@export var offset : Vector2 :
	set(value):
		offset = value
		update_offset()

func _ready():
	update_offset()

func change_shader(shader: Enums.Shaders) -> void:
	material = References.SHADERS[shader]
	
func remove_shader() -> void:
	material = null

func update_offset() -> void:	
	for child in get_children():
		child.offset = offset
