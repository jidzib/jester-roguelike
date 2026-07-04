class_name Hurtbox extends Area2D

var parent_stats : Stats

func _ready() -> void:
	parent_stats = owner.stats
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	# SET LAYER DEPENDING ON TEAM
	set_collision_layer_value(parent_stats.team, true)
	
func receive_hit(damage : int) -> void:
	parent_stats.take_damage(damage)
	parent_stats.owner.sprites.change_shader(Enums.Shaders.HIT_FLASH)
	await get_tree().create_timer(0.25).timeout
	parent_stats.owner.sprites.remove_shader()
	# hitflash
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
