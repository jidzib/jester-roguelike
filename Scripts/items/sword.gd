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
	var shape : Shape2D = RectangleShape2D.new()
	var hitbox : Hitbox = Hitbox.new(entity.stats, attack_lifetime, shape, References.HIT_EFFECTS[hit_effect])
	hitbox.position = target_dir * range + entity.center.position
	entity.add_child(hitbox)
	entity.change_state(entity.state_nodes[entity.States.ATTACKING])
	
	AudioManager.play_randomized_sound(use_sound)
