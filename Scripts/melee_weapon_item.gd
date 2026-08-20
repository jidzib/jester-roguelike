class_name MeleeWeaponItem extends WeaponItem

@export var range : float = 10.0
@export var attack_speed : float = 1.0
@export var hitbox_size : float = 20.0
#@export var attack_lifetime : float = 0.2
@export var slow_effect : float = 0.5
@export var hit_effect : Enums.HitEffects = Enums.HitEffects.SWORD_HIT
@export var use_sound : AudioStream

@export var attack_name : String


# NEED TO PASS IN A TARGET TO DIFFERENTIATE 
# BETWEEN PLAYER AND ENEMY ATTACKS
func use(entity: Entity, target_dir: Vector2) -> void:
	#entity.hurtbox.damage = damage
	# spawn hitbox in
	
	var entity_attack_state : State = entity.state_nodes[entity.States.ATTACKING]
	var new_animation : WeaponAnimation = animation.instantiate()
	var shape : Shape2D = RectangleShape2D.new() # For different weapons add a shape type
	shape.size = Vector2(hitbox_size, hitbox_size)
	
	var attack_timings : Dictionary[String, float] = apply_attack_speed(
								attack_duration, entity_attack_state.windup_duration, new_animation.windup_point)

	var hitbox : Hitbox = Hitbox.new(entity.stats, attack_timings["attack_duration"] - 
									attack_timings["windup_duration"],
									shape, References.HIT_EFFECTS[hit_effect], self)
	hitbox.position = target_dir * range + entity.center.position

	entity_attack_state.initialize(attack_timings["attack_duration"], attack_name, 
							attack_timings["windup_point"],
							slow_effect, attack_speed)
	entity.change_state(entity_attack_state)
	spawn_animation(new_animation, entity, target_dir, new_animation.windup_point, attack_speed)
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
		"windup_point" : _windup_point
	}
	return attack_timings
