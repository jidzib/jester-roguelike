class_name Item extends Resource

@export var texture : Texture2D
@export var ID : int

@export var name : String
@export_multiline var description : String

func use(entity: Entity) -> void:
	pass
