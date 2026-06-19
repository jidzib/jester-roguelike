class_name Sword extends Item

@export var damage : int

func use(entity: Entity) -> void:
	entity.hurtbox.damage = damage
	entity.change_state(entity.state_nodes[entity.States.ATTACKING])
