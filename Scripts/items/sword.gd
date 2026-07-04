class_name Sword extends Item

@export var damage : int
@export var range : float
@export var attack_lifetime : float

# NEED TO PASS IN A TARGET TO DIFFERENTIATE 
# BETWEEN PLAYER AND ENEMY ATTACKS
func use(entity: Entity, target_dir: Vector2) -> void:
	#entity.hurtbox.damage = damage
	# spawn hitbox in
	var shape : Shape2D = RectangleShape2D.new()
	var hitbox : Hitbox = Hitbox.new(entity.stats, attack_lifetime, shape)
	hitbox.position = target_dir * range
	entity.add_child(hitbox)
	entity.change_state(entity.state_nodes[entity.States.ATTACKING])
