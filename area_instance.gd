@tool
class_name DungeonArea
extends Node2D

@export var floor_source_id : int = 0
@export var floor_atlas_coords : Vector2i = Vector2i(0, 0)

var data : AreaData
@export var tile_map : TileMapLayer

func setup(p_data: AreaData) -> void:
	data = p_data
	global_position = data.bounds.position
	_paint_tiles()
	_spawn_content()

func _paint_tiles() -> void:
	tile_map.clear()
	for cell in data.tile_cells:
		
		tile_map.set_cell(cell, floor_source_id, floor_atlas_coords)

func _spawn_content() -> void:
	for point in data.enemy_spawn_points:
		pass # instantiate enemy scene, position = point (local to this node)
	for point in data.loot_spawn_points:
		pass # instantiate loot scene, position = point (local to this node)

func teardown() -> void:
	queue_free()
