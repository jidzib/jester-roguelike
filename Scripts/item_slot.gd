@tool
class_name ItemSlot extends Control

signal change_slot(_item: Item)
signal fill_slot(_item: Item)

@export var item : Item :
	set(value):
		change_slot.emit(item)
		item = value
		update_display()
		fill_slot.emit(item)
		#update_slot.emit()
		
var selected : bool = false
@export var sprite : Sprite2D
@export var selected_sprite : Sprite2D

@export var item_description : ItemDescription

func _ready() -> void:
	z_index = 1

func remove_item() -> void:
	item = null
	update_display()
	
func update_display() -> void:
	if not sprite:
		return
	if item:
		sprite.texture = item.texture
	else:
		sprite.texture = null
	if selected:
		selected_sprite.visible = true
	else:
		selected_sprite.visible = false

	
func _get_drag_data(at_position: Vector2) -> Variant:
	if item:
		var preview_container : Control = Control.new()
		var preview : TextureRect = TextureRect.new()
		preview.texture = item.texture
		preview.position = Vector2(-8, -8)
		#z_index = 1
		#preview_container.z_index = 1
		#preview.z_index = 1
		preview_container.add_child(preview)
		set_drag_preview(preview_container)
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data.item:
		return true
	return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var temp_item : Item = item
	item = data.item
	data.item = temp_item
	
func _on_mouse_entered() -> void:
	if item:
		item_description.visible = true

func _on_mouse_exited() -> void:
	item_description.visible = false
