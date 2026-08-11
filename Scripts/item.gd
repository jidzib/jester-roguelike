class_name Item extends Resource

@export var texture : Texture2D
@export var ID : Enums.Items
@export var name : String
@export var rarity : Items.RARITY
@export_multiline var description : String


func use(entity: Entity, target_dir: Vector2) -> void:
	pass
