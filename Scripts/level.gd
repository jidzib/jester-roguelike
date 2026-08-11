class_name Level extends Node2D

@export var current_level : int = 0
@export var level_size : Vector2i = Vector2i(12, 12)
var loot_scene : PackedScene = load("uid://jvhbrpdhcuwa")

@export var levels_data : Array[LevelData]

var active_enemy_count : int = 0 :
	set(value):
		active_enemy_count = value

func _ready():
	level_size = Vector2i(level_size.x-1, level_size.y-1)
	initialize_level()

func reset_level() -> void:
	active_enemy_count = 0
	initialize_level()
	
func initialize_level() -> void:
	var occupied_positions : Dictionary[Vector2, bool] = {}
	for id in levels_data[current_level].enemies:
		var random_pos : Vector2 = pick_random_unoccupied_position(occupied_positions)
		occupied_positions.set(random_pos, true)
		spawn_enemy(id, pick_random_position())
		
	#for i in range(current_level):
		#spawn_enemy(Util.RNG.randi_range(0, Enums.Enemies.size()-1), pick_random_position())

func spawn_enemy(enemy_id: Enums.Enemies, _position: Vector2) -> void:
	var enemy : Entity = References.ENEMIES[enemy_id].instantiate()
	enemy.position = _position
	add_child(enemy)
	active_enemy_count += 1
	enemy.died.connect(decrement_active_enemy_count)

func pick_random_unoccupied_position(occupied_positions: Dictionary[Vector2, bool]) -> Vector2:
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
	loot.tree_exited.connect(reset_level)
	add_child(loot)
	
func decrement_active_enemy_count() -> void:
	active_enemy_count -= 1
	if no_enemies_remaining():
		current_level += 1
		print("current level", current_level)
		if current_level < levels_data.size():
			spawn_loot(levels_data[current_level].loot_size)
		else:
			print("You beat the game")
			
func no_enemies_remaining() -> bool:
	return active_enemy_count <= 0
