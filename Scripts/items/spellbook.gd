class_name SpellbookItem extends WeaponItem

#var projectile : PackedScene = load("res://Scenes/Projectile.tscn")
@export var projectile_id : Enums.Projectiles # NEW
@export var mana_cost : int = 5
@export var spawn_hitbox : bool = true
var cast_duration : float = 0.5

@export var animation_range : float = 16.0

func use(entity: Entity, target_dir: Vector2) -> void:
	if not entity.stats.has_enough_mana(mana_cost):
		return
	entity.stats.use_mana(mana_cost)
	#var new_projectile : Projectile = projectile.instantiate()
	var new_projectile : Projectile = References.PROJECTILES[projectile_id].instantiate() # NEW
	new_projectile.initialize(entity.stats, spawn_hitbox)
	
	new_projectile.global_position = entity.global_position
	new_projectile.direction = target_dir
	entity.cardinal_direction = entity.get_cardinal_direction(target_dir)
	entity.set_facing(entity.cardinal_direction)
	entity.add_child(new_projectile)
	
	var spellcasting_state : State = entity.state_nodes[entity.States.SPELLCASTING]
	entity.change_state(spellcasting_state)
	spellcasting_state.duration = cast_duration
	var new_animation : WeaponAnimation = animation.instantiate()
	spellcasting_state.initialize(new_animation)
	spellcasting_state.start_timer()
	var animation_data : AnimationData = AnimationData.new()
	animation_data.direction = entity.facing
	spawn_animation(new_animation, entity, target_dir, animation_data, 1.0, animation_range)
	
func has_enough_mana(entity: Entity) -> bool:
	if entity.current_mana >= mana_cost:
		return true
	return false
