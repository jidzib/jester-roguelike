extends PotionItem

@export var heal_amount : int = 1

func use(entity: Entity) -> void:
	#entity.gain_hp.emit(heal_amount)
	entity.stats.heal(heal_amount)
	entity.change_state(entity.state_nodes[entity.States.DRINKING_POTION])
	
