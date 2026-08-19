class_name MeleeWeaponItem extends WeaponItem

@export var range : float = 20.0
@export var hitbox_size : float = 20.0
@export var attack_lifetime : float = 0.2
@export var hit_effect : Enums.HitEffects = Enums.HitEffects.SWORD_HIT
@export var use_sound : AudioStream

@export var attack_name : String


# NEED TO PASS IN A TARGET TO DIFFERENTIATE 
# BETWEEN PLAYER AND ENEMY ATTACKS
func use(entity: Entity, target_dir: Vector2) -> void:
	#entity.hurtbox.damage = damage
	# spawn hitbox in
	
	var entity_attack_state : State = entity.state_nodes[entity.States.ATTACKING]
	var shape : Shape2D = RectangleShape2D.new() # For different weapons add a shape type
	shape.size = Vector2(hitbox_size, hitbox_size)
	var hitbox : Hitbox = Hitbox.new(entity.stats, entity_attack_state.duration - 
									entity_attack_state.wind_up_duration,
									shape, References.HIT_EFFECTS[hit_effect], self)
	hitbox.position = target_dir * range + entity.center.position
	var new_animation : WeaponAnimation = animation.instantiate()
	entity_attack_state.windup_point = new_animation.windup_point
	entity_attack_state.attack_name = attack_name
	entity_attack_state.duration = attack_duration
	entity.change_state(entity_attack_state)
	spawn_animation(new_animation, entity, target_dir, entity_attack_state.wind_up_duration)
	await entity_attack_state.wind_up_finished
	entity.add_child(hitbox)
	AudioManager.play_randomized_sound(use_sound)
	
