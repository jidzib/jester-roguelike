class_name MeleeWeaponItem extends WeaponItem

@export var range : float = 10.0
@export var attack_speed : float = 1.0
@export var hitbox_size : float = 20.0
@export var hitbox_start : float = 0.3
@export var hitbox_end : float = 0.4
#@export var attack_lifetime : float = 0.2
@export var slow_effect : float = 0.5
@export var hit_effect : Enums.HitEffects = Enums.HitEffects.SWORD_HIT
@export var use_sound : AudioStream

@export var attack_name : String


# NEED TO PASS IN A TARGET TO DIFFERENTIATE 
# BETWEEN PLAYER AND ENEMY ATTACKS
func use(entity: Entity, target_dir: Vector2) -> void:

	var entity_attack_state : AttackingState = entity.state_nodes[entity.States.ATTACKING]
	var new_animation : WeaponAnimation = animation.instantiate()
	var shape : Shape2D = RectangleShape2D.new()
	shape.size = Vector2(hitbox_size, hitbox_size)
	
	var attack_timings : Dictionary[String, float] = apply_attack_speed(
								attack_duration, entity_attack_state.windup_duration, new_animation.windup_point)
	var animation_data : AnimationData = AnimationData.new(attack_timings["windup_point"],
														   attack_timings["windup_duration"],
														   entity.facing)
	
	var hitbox : Hitbox = Hitbox.new(entity.stats, attack_timings["hitbox_end"] - attack_timings["hitbox_start"],
									shape, References.HIT_EFFECTS[hit_effect], self)							
	hitbox.position = target_dir * range + entity.center.position
	
	var a_duration : float = attack_timings["windup_duration"] + attack_timings["hitbox_end"] - attack_timings["windup_point"]
	entity_attack_state.initialize(animation_data,
						a_duration,
						attack_name, slow_effect, attack_speed, new_animation)
	entity.change_state(entity_attack_state)
	spawn_animation(new_animation, entity, target_dir, animation_data, attack_speed, range-hitbox_size/2)
	await entity_attack_state.wind_up_finished
	
	entity.add_child(hitbox)
	AudioManager.play_randomized_sound(use_sound)

func apply_attack_speed(_attack_duration: float, _windup_duration: float, _windup_point: float) -> Dictionary[String, float]:
	if _windup_duration > 0:
		_windup_duration /= attack_speed
	if _windup_point > 0:
		_windup_point /= attack_speed
	var attack_timings : Dictionary[String, float] = {
		"attack_duration" : _attack_duration / attack_speed,
		"windup_duration" : _windup_duration,
		"windup_point" : _windup_point,
		"hitbox_start" : hitbox_start / attack_speed,
		"hitbox_end" : hitbox_end / attack_speed
	}
	return attack_timings
