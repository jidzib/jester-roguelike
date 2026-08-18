class_name WeaponItem extends Item

@export var power : int = 1.0
@export var animation : PackedScene
@export var ATTACK_TYPE : CombatManager.COMBAT_STATS
@export var attack_duration : float = 0.6

func spawn_animation(_new_animation: WeaponAnimation, entity: Entity, _windup_duration: float = 0.0) -> void:
	var new_animation : WeaponAnimation = animation.instantiate()
	new_animation.scale.x = entity.sprites.scale.x
	entity.held_item.add_child(new_animation)
	new_animation.global_position = entity.sprites.global_position
	entity.held_item.anchor.hide()
	entity.held_item.locked = true
	new_animation.animation_finished.connect(entity.held_item.animation_done)
	new_animation.z_as_relative = true
	
	if entity.facing == "back":
		new_animation.z_index = -1
	else:
		new_animation.z_index = 1
	new_animation.play(entity.facing, _windup_duration)
	#if _wait_signal:
		#new_animation.wait(_wait_signal)
