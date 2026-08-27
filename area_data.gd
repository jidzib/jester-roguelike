class_name AreaData extends Resource

enum AREA_TYPES {
	ROOM,
	CORRIDOR
}

@export var id : int
@export var bounds : Rect2
@export var area_type : AREA_TYPES
@export var tile_cells : Array[Vector2i] = [] 
@export var connections : Array[int] = [] # IDs of connected Areas
@export var enemy_spawn_points : Array[Vector2] = []
@export var loot_spawn_points : Array[Vector2] = []

var instance : Node2D = null
