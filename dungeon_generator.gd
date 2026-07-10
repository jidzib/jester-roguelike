@tool
class_name DungeonGenerator extends Node

const TILE_DATA : Dictionary[String, Dictionary] = {
	"floor" : {
		"source_id" : 0,
		"atlas_coords" : Vector2(0, 1)
	},
	"wall" : {
		"source_id" : 0,
		"atlas_coords" : Vector2(1, 1)
	},
}

@export var tile_layer : TileMapLayer
@export var dungeon_size : Vector2i = Vector2i(8, 8)
@export_tool_button("Generate Dungeon") var dungeon_gen_button = generate_dungeon
@export_tool_button("Clear All") var clear_tiles_button = clear
var dirs : Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]

@export var max_steps : int = 20

func clear() -> void:
	tile_layer.clear()

func generate_dungeon() -> void:
	generate_walls()
	carve_floors()

func generate_walls() -> void:
	for x in range(dungeon_size.x):
		for y in range(dungeon_size.y):
			tile_layer.set_cell(Vector2(x, y), TILE_DATA.wall.source_id, TILE_DATA.wall.atlas_coords)

func carve_floors() -> void:
	var current_position : Vector2i = Vector2i(
		floor(dungeon_size.x / 2.0),
		floor(dungeon_size.y / 2.0))
	for i in range(max_steps):
		tile_layer.set_cell(current_position, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
		var move_dir : Vector2i = dirs.pick_random()
		var new_pos : Vector2i = current_position + move_dir
		if in_bounds(new_pos):
			current_position = new_pos
		else:
			dirs.shuffle()
			for d in dirs:
				if in_bounds(current_position+d):
					current_position += d
					break
	
func in_bounds(tile: Vector2i) -> bool:
	if tile.x < 0 or tile.x >= dungeon_size.x or tile.y < 0 or tile.y >= dungeon_size.y:
		return false
	return true
