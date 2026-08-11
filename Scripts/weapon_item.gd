class_name WeaponItem extends Item

@export var power : int = 1.0
@export var animation : PackedScene
@export var ATTACK_TYPE : Stats.COMBAT_STATS

func spawn_animation(_new_animation: WeaponAnimation, entity: Entity, _windup_duration: float = 0.0) -> void:
	var new_animation : WeaponAnimation = animation.instantiate()
	entity.sprites.add_child(new_animation)
	new_animation.z_as_relative = true
	new_animation.z_index = 1
	new_animation.play(entity.facing, _windup_duration)
	#if _wait_signal:
		#new_animation.wait(_wait_signal)
