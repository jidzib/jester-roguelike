class_name Level extends Node2D

@export var current_level : int = 1

@export var level_size : Vector2i = Vector2i(12, 12)
var loot_scene : PackedScene = load("uid://jvhbrpdhcuwa")

@export var level_tiers : Dictionary[LevelTier.LevelTiers, LevelTier] = {
	LevelTier.LevelTiers.EASY : load("uid://cm2brn5s2fx0c"),
	LevelTier.LevelTiers.MEDIUM : load("uid://dtwkvasgalb7r"),
	LevelTier.LevelTiers.HARD : load("uid://bgthyhcto04kr"),
	LevelTier.LevelTiers.EXTREME : load("uid://by8qc35yqgg8n")
}

var active_enemy_count : int = 0 :
	set(value):
		active_enemy_count = value

func _ready():
	level_size = Vector2i(level_size.x-1, level_size.y-1)
	initialize_level()

@export_category("Level Thresholds")
@export var easy_threshold : int = 3
@export var medium_threshold : int = 6
@export var hard_threshold : int = 9
@export var extreme_threshold : int = 12

func pick_level(_current_level: int) -> LevelTier:
	if _current_level <= easy_threshold:
		return level_tiers[LevelTier.LevelTiers.EASY]
	elif _current_level <= medium_threshold:
		return level_tiers[LevelTier.LevelTiers.MEDIUM]
	elif _current_level <= hard_threshold:
		return level_tiers[LevelTier.LevelTiers.HARD]
	else:
		return level_tiers[LevelTier.LevelTiers.EXTREME]

func start_next_level() -> void:
	if not get_tree():
		return
	await get_tree().create_timer(3.0).timeout
	current_level += 1
	active_enemy_count = 0
	initialize_level()
	
func initialize_level() -> void:
	var tier : LevelTier = pick_level(current_level)
	var num_enemies : int = randi_range(tier.enemy_count_range.x, tier.enemy_count_range.y)
	spawn_enemies(num_enemies, tier.enemy_pool)
	

var spawn_indicator_texture : Texture = preload("uid://br5jvc3s1qri8")

func spawn_enemies(num_enemies: int, enemy_pool: Dictionary[Enums.Enemies, bool], with_delay: float = 1.0) -> void:
	var occupied_positions : Dictionary[Vector2, Sprite2D] = {}
	for i in range(num_enemies):
		#var enemy_id : Enums.Enemies = enemy_pool.keys().pick_random()
		var random_pos : Vector2 = pick_random_unoccupied_position(occupied_positions)
		#spawn_enemy(enemy_id, random_pos)
		var spawn_indicator : Sprite2D = Sprite2D.new()
		spawn_indicator.texture = spawn_indicator_texture
		spawn_indicator.position = random_pos
		occupied_positions.set(random_pos, spawn_indicator)
		add_child(spawn_indicator)
	
	await get_tree().create_timer(with_delay).timeout
	
	for pos in occupied_positions:
		var enemy_id : Enums.Enemies = enemy_pool.keys().pick_random()
		spawn_enemy(enemy_id, pos)
		occupied_positions[pos].queue_free()
		#occupied_positions.erase(pos)
	occupied_positions.clear()
func spawn_enemy(enemy_id: Enums.Enemies, _position: Vector2) -> void:
	var enemy : Enemy = References.ENEMIES[enemy_id].instantiate()
	enemy.position = _position
	add_child(enemy)
	active_enemy_count += 1
	enemy.died.connect(decrement_active_enemy_count)
	if Player.player:
		enemy.send_points_value.connect(Player.player.scoreboard.increase_score)
		
func pick_random_unoccupied_position(occupied_positions: Dictionary[Vector2, Sprite2D]) -> Vector2:
	while true:
		var random_pos: Vector2 = pick_random_position()
		if random_pos not in occupied_positions:
			return random_pos
	return Vector2.ZERO

func pick_random_position() -> Vector2:
	return Vector2(Util.RNG.randi_range(-level_size.x/2, level_size.x/2),
	 Util.RNG.randi_range(-level_size.y/2, level_size.y/2)) * Util.TILE_SIZE

func spawn_loot(loot_level: int) -> void:
	var loot : Loot = loot_scene.instantiate()
	loot.global_position = Player.player.global_position
	loot.level = loot_level
	add_child(loot)
	await loot.tree_exited

func decrement_active_enemy_count() -> void:
	active_enemy_count -= 1
	if no_enemies_remain():
		Player.player.scoreboard.increase_score(min(4, current_level))
		await spawn_loot(pick_level(current_level).loot_tier)
		start_next_level()


func no_enemies_remain() -> bool:
	return active_enemy_count <= 0
