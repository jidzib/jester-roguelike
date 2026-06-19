class_name Shield extends Item

func use(entity: Entity) -> void:
	entity.change_state(entity.state_nodes[entity.States.BLOCKING])
