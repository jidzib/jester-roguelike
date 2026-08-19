class_name HeldItem extends Node2D

@export var item_slot : ItemSlot :
	set(value):
		if item_slot:
			item_slot.fill_slot.disconnect(update_item)
		item_slot = value
		item_slot.fill_slot.connect(update_item)
		item = item_slot.item
		
@export var item : Item :
	set(value):
		item = value
		update_display()
@export var sprite : Sprite2D

func _ready() -> void:
	item_slot.fill_slot.connect(update_item)
	sprite.rotation_degrees = -45.0

func update_item(_item: Item) -> void:
	item = _item

func update_display() -> void:
	if item:
		sprite.texture = item.texture
		visible = true
	else:
		if sprite:
			sprite.texture = null
		visible = false
		
		
@export var anchor : Control
var target_pos : Vector2

var max_distance : float = 12.0
var weapon_angle : float

var locked : bool = false

func _process(delta: float) -> void:
	if locked:
		return
	var dir : Vector2 = global_position.direction_to(target_pos)
	var angle : float = global_position.angle_to_point(target_pos)
	var distance : float = global_position.distance_to(target_pos)
	distance = clamp(distance, 0, max_distance)
	weapon_angle = global_position.angle_to_point(target_pos)
	
	if rad_to_deg(weapon_angle) > -180 and rad_to_deg(weapon_angle) < 0:
		sprite.z_index = 0
	else:
		sprite.z_index = 1
	
	sprite.global_position = Vector2(global_position.x + distance * cos(weapon_angle), global_position.y + distance * sin(weapon_angle))
	anchor.rotation = weapon_angle

func animation_done() -> void:
	sprite.show()
	locked = false
