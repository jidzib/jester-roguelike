class_name SpellbookItem extends Item

var projectile : PackedScene = load("res://Scenes/Projectile.tscn")
var mana_cost : int = 20
var cast_duration : float = 0.5

func use(entity: Entity, target_dir: Vector2) -> void:
	if not entity.stats.has_enough_mana(mana_cost):
		return
	entity.stats.use_mana(mana_cost)
	var new_projectile : Projectile = projectile.instantiate()
	new_projectile.initialize(entity.stats)
	
	new_projectile.global_position = entity.global_position
	new_projectile.direction = entity.center.global_position.direction_to(entity.get_global_mouse_position())
	entity.cardinal_direction = entity.get_cardinal_direction(entity.center.global_position.direction_to(entity.get_global_mouse_position()))
	entity.set_facing(entity.cardinal_direction)	
	entity.add_child(new_projectile)
	
	var spellcasting_state : State = entity.state_nodes[entity.States.SPELLCASTING]
	entity.change_state(spellcasting_state)
	spellcasting_state.duration = cast_duration
	spellcasting_state.start_timer()
	
	
func has_enough_mana(entity: Entity) -> bool:
	if entity.current_mana >= mana_cost:
		return true
	return false
