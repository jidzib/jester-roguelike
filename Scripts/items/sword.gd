class_name Sword extends Item

@export var damage : int
@export var range : float
@export var attack_lifetime : float
@export var hit_effect : Enums.HitEffects
@export var use_sound : AudioStream
# NEED TO PASS IN A TARGET TO DIFFERENTIATE 
# BETWEEN PLAYER AND ENEMY ATTACKS
func use(entity: Entity, target_dir: Vector2) -> void:
	#entity.hurtbox.damage = damage
	# spawn hitbox in
	var entity_attack_state : State = entity.state_nodes[entity.States.ATTACKING]
	var shape : Shape2D = RectangleShape2D.new()
	var hitbox : Hitbox = Hitbox.new(entity.stats, entity_attack_state.duration - 
									entity_attack_state.wind_up_duration,
									shape, References.HIT_EFFECTS[hit_effect])
	hitbox.position = target_dir * range + entity.center.position
	entity.state_nodes[entity.States.ATTACKING].target_dir = target_dir
	entity.change_state(entity_attack_state)
	await entity_attack_state.wind_up_finished
	entity.add_child(hitbox)
	AudioManager.play_randomized_sound(use_sound)
