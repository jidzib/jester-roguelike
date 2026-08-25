class_name WeaponItem extends Item

@export var power : int = 20.0
@export var animation : PackedScene
@export var ATTACK_TYPE : CombatManager.COMBAT_STATS
@export var attack_duration : float = 0.3


func spawn_animation(_new_animation: WeaponAnimation, entity: Entity, target_dir: Vector2,
					_windup_duration: float = 0.0, _playback_speed: float = 1.0, _range: float = 0.0) -> void:

	
	var new_animation : WeaponAnimation = animation.instantiate()
	if entity.current_state == entity.States.ATTACKING:
		entity.state_nodes[entity.States.ATTACKING].attack_finished.connect(new_animation.despawn)
	entity.held_item.anchor.add_child(new_animation)
	entity.held_item._set_position(_range, new_animation)
	entity.held_item.sprite.hide()
	
	entity.held_item.locked = true
	new_animation.z_as_relative = true
	
	if entity.facing == "back":
		new_animation.z_index = -1
	else:
		new_animation.z_index = 1
	new_animation.play(entity.facing, _windup_duration, _playback_speed)
