class_name Hurtbox extends Area2D

var parent_stats : Stats

func _ready() -> void:
	parent_stats = owner.stats
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	# SET LAYER DEPENDING ON TEAM
	
func receive_hit(damage : int) -> void:
	parent_stats.take_damage(damage)
	# knockback
	
#signal landed_hit
#
#@export var parent : Entity
#@export var damage : int
#var attack_type : String
#
#@export var collision_shape : CollisionShape2D
#
#@export var disabled : bool :
	#set(value):
		#disabled = value
		#update_activity(disabled)
	#
#@export var particles : GPUParticles2D
#
#func hurtbox() -> void:
	#pass
#
#func update_activity(_disabled : bool) -> void:
	#collision_shape.disabled = _disabled
#
#func update_attack_type(_attack_type: String) -> void:
	#attack_type = _attack_type
