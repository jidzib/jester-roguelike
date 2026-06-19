@tool
class_name HeldItem extends Node2D
@export var item : Item :
	set(value):
		item = value
		update_display()
@export var sprite : Sprite2D

func update_display() -> void:
	visible = false
	return
	if item:
		sprite.texture = item.texture
		visible = true
	else:
		sprite.texture = null
		visible = false
