@tool
class_name DungeonStreamer
extends Node2D

@export var load_radius : float = 400.0
var all_areas : Array[AreaData] = []
var area_instance_scene : PackedScene = preload("uid://fw6ayg0d66lg")
var trigger_zones : Dictionary = {} # id -> Area2D

func setup(areas: Array[AreaData]) -> void:
	clear()
	all_areas = areas
	for data in all_areas:
		_create_trigger_zone(data)
	load_all()
	
func _create_trigger_zone(data: AreaData) -> void:
	var trigger := Area2D.new()
	var shape := CollisionShape2D.new()
	var rect_shape := RectangleShape2D.new()
	
	trigger.visible = false
	# padded bounds - the load zone is bigger than the room itself
	var padded : Rect2 = data.bounds.grow(load_radius)
	rect_shape.size = padded.size
	shape.shape = rect_shape
	trigger.position = padded.get_center()
	trigger.add_child(shape)
	add_child(trigger)

	trigger.body_entered.connect(_on_player_entered.bind(data))
	trigger.body_exited.connect(_on_player_exited.bind(data))
	trigger_zones[data.id] = trigger

func _on_player_entered(body: Node, data: AreaData) -> void:
	if !body.is_in_group("player"):
		return
	_load_area(data)

func _on_player_exited(body: Node, data: AreaData) -> void:
	if !body.is_in_group("player"):
		return
	_unload_area(data)

func _load_area(data: AreaData) -> void:
	if data.instance != null:
		return
	var inst : DungeonArea = area_instance_scene.instantiate()
	add_child(inst)
	inst.setup(data)
	data.instance = inst

func _unload_area(data: AreaData) -> void:
	if data.instance == null:
		return
	data.instance.teardown()
	data.instance = null

func load_all() -> void:
	for data in all_areas:
		_load_area(data)

func clear() -> void:
	for id in trigger_zones.keys():
		trigger_zones[id].queue_free()
	trigger_zones.clear()
	for data in all_areas:
		if data.instance != null:
			data.instance.queue_free()
			data.instance = null
	all_areas.clear()
