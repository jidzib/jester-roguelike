class_name LightningProjectile extends Projectile

@export var chain_area : Area2D
@export var max_enemies_hit : int
var hurtboxes_in_chain_range : Dictionary[Hurtbox, bool] = {}

func _ready() -> void:
	chain_area.area_entered.connect(add_chainable)
	chain_area.area_exited.connect(remove_chainable)
	super()

func add_chainable(area: Area2D) -> void:
	if area is not Hurtbox or same_team(area):
		return
	hurtboxes_in_chain_range.set(area, true)
func remove_chainable(area: Area2D) -> void:
	if area is not Hurtbox or same_team(area):
		return
	hurtboxes_in_chain_range.erase(area)
	
func charge() -> void:
	animation_player.play("charging")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	charged.emit()

func _on_hurtbox_landed_hit(entry: Stats) -> void:
	set_physics_process(false)
	var closest_areas : Array[Dictionary] = get_closest_enemies()
	apply_chain(closest_areas)
	animation_player.play("explode")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	queue_free()

func same_team(hurtbox: Hurtbox) -> bool:
	return hurtbox.parent_stats.team == hitbox.parent_stats.team

func get_closest_enemies() -> Array[Dictionary]:
	var k_closest_areas : Array[Dictionary] = []
	for area in hurtboxes_in_chain_range.keys():
		var distance : float = global_position.distance_to(area.global_position)
		k_closest_areas.append({"area":area, "distance":distance})
	k_closest_areas.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return k_closest_areas

func apply_chain(k_closest_areas: Array[Dictionary]) -> void:
	var hit_count : int = 0
	for area in k_closest_areas:
		if hitbox.try_hit(area["area"], true):
			hit_count += 1
		if hit_count >= max_enemies_hit:
			return

func get_top_k(arr: Array, k: int) -> Array:
	var sorted = arr.duplicate()
	sorted.sort()
	sorted.reverse() # Sorts descending
	return sorted.slice(0, k)
