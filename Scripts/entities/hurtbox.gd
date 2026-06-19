class_name Hurtbox extends Area2D

signal landed_hit

@export var parent : Entity
@export var damage : int
var attack_type : String

@export var collision_shape : CollisionShape2D

@export var disabled : bool :
	set(value):
		disabled = value
		update_activity(disabled)
	

func hurtbox() -> void:
	pass

func update_activity(_disabled : bool) -> void:
	collision_shape.disabled = _disabled

func update_attack_type(_attack_type: String) -> void:
	attack_type = _attack_type
