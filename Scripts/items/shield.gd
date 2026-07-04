class_name Shield extends Item

func use(entity: Entity, target_dir: Vector2) -> void:
	entity.change_state(entity.state_nodes[entity.States.BLOCKING])
