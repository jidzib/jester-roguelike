class_name SpriteGroup extends CanvasGroup

func change_shader(shader: Enums.Shaders) -> void:
	material = References.SHADERS[shader]
	
func remove_shader() -> void:
	material = null
