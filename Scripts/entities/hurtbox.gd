class_name Hurtbox extends Area2D

var parent_stats : Stats
var blocking : bool = false
signal successful_parry

var parry_hit_effect : HitEffect = References.HIT_EFFECTS[Enums.HitEffects.PARRY_HIT]

func _ready() -> void:
	parent_stats = owner.stats
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	# SET LAYER DEPENDING ON TEAM
	set_collision_layer_value(parent_stats.team, true)

func is_blocking() -> bool:
	return blocking

func receive_hit(damage : int, coming_from: Vector2, knockback_strength : float = 100.0) -> void:
	parent_stats.take_damage(damage)
	var parent : Entity = parent_stats.owner
	parent.hit_flash()
	Camera.camera.camera_shake(damage)
	# knockback
	var hurt_state : State = parent.state_nodes[parent.States.HURT]
	hurt_state.knockback_strength = knockback_strength
	hurt_state.knockback_direction = coming_from
	parent.change_state(hurt_state)
	
