extends PotionItem

@export var restore_amount : int = 20

func use(entity: Entity, target_dir: Vector2) -> void:
	entity.stats.restore_mana(restore_amount)
	entity.change_state(entity.state_nodes[entity.States.DRINKING_POTION])
