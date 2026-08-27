class_name WeaponItem extends Item

@export var power : int = 20.0
@export var animation : PackedScene
@export var ATTACK_TYPE : CombatManager.COMBAT_STATS
@export var attack_duration : float = 0.3


func spawn_animation(_new_animation: WeaponAnimation, entity: Entity, target_dir: Vector2,
					_animation_data: AnimationData, _playback_speed: float = 1.0, _range: float = 0.0) -> void:

	entity.held_item.anchor.add_child(_new_animation)
	entity.held_item._set_position(_range, _new_animation)
	entity.held_item.sprite.hide()
	
	entity.held_item.locked = true
	_new_animation.z_as_relative = true
	
	if entity.facing == "back":
		_new_animation.z_index = -1
	else:
		_new_animation.z_index = 1
	_new_animation.play(_animation_data, _playback_speed)
