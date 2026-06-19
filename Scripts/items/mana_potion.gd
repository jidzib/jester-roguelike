extends PotionItem

@export var restore_amount : int = 20

func use(entity: Entity) -> void:
	entity.gain_mana.emit(restore_amount)
	entity.change_state(entity.state_nodes[entity.States.DRINKING_POTION])
