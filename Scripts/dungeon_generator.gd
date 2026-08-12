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

@export var max_steps : int = 32

func clear() -> void:
	tile_layer.clear()

func generate_dungeon() -> void:
	pass
	

var rooms : Array[Rect2] = []
var max_attemps: int = 1000
var min_room_size : int = 8
var max_room_size : int = 16


func generate_rooms(room_count: int) -> void:
	var attemps : int = 0
	
	while rooms.size() < room_count and attemps < max_attemps:
		attemps += 1
		var room_size : Vector2i = Vector2i(randi_range(min_room_size, max_room_size),
		 									randi_range(min_room_size, max_room_size))
		var room_position : Vector2i = Vector2i(randi_range(0, dungeon_size.x),
												randi_range(0, dungeon_size.y))
		var room : Rect2 = Rect2(room_position, room_size)
		
		var overlaps : bool = false
		for existing_room in rooms:
			if room.intersects(existing_room):
				overlaps = true
				break
		if not overlaps:
			rooms.append(room)
		
func find_closest_room(room: Rect2) -> Rect2:
	var closest_room : Rect2
	var closest_distance : float = INF
	for other_room in rooms:
		if other_room == room:
			continue
		var distance : float = room.get_center().distance_to(other_room.get_center())
		
		if distance < closest_distance:
			closest_distance = distance
			closest_room = other_room	
	return closest_room

func connect_rooms(room_a: Rect2, room_b: Rect2) -> void:
	pass
func in_bounds(tile: Vector2i) -> bool:
	if tile.x < 0 or tile.x >= dungeon_size.x or tile.y < 0 or tile.y >= dungeon_size.y:
		return false
	return true
