class_name WeaponItem extends Item

@export var power : int = 1.0
@export var animation : PackedScene
@export var ATTACK_TYPE : CombatManager.COMBAT_STATS
@export var attack_duration : float = 0.6

func spawn_animation(_new_animation: WeaponAnimation, entity: Entity, target_dir: Vector2, _windup_duration: float = 0.0) -> void:
	var new_animation : WeaponAnimation = animation.instantiate()
	#new_animation.scale.x = entity.sprites.scale.x
	
	entity.held_item.anchor.add_child(new_animation)
	#new_animation.global_position = entity.sprites.global_position
	new_animation.global_position = Vector2(
		entity.held_item.global_position.x + 8 * cos(entity.held_item.weapon_angle), entity.held_item.global_position.y + 8 * sin(entity.held_item.weapon_angle))
	#new_animation.rotation_degrees = 45.0
	entity.held_item.sprite.hide()
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
