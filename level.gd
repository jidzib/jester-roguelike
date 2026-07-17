class_name Level extends Node2D

@export var level_number : int = 1
@export var level_size : Vector2i = Vector2i(28, 18)

var loot_scene : PackedScene = load("uid://jvhbrpdhcuwa")

var active_enemy_count : int = 0 :
	set(value):
		active_enemy_count = value
		if active_enemy_count <= 0: # <- spawn loot bag and transfer to next level
			spawn_loot()
			print("no enemies remaining")

func _ready():
	initialize_level()

func initialize_level() -> void:
	for i in range(level_number):
		spawn_enemy(Util.RNG.randi_range(0, Enums.Enemies.size()-1), pick_random_position())

func spawn_enemy(enemy_id: Enums.Enemies, _position: Vector2) -> void:
	var enemy : Entity = References.ENEMIES[enemy_id].instantiate()
	enemy.position = _position
	add_child(enemy)
	active_enemy_count += 1
	enemy.died.connect(decrement_active_enemy_count)
	
func pick_random_position() -> Vector2:
	return Vector2(Util.RNG.randi_range(-level_size.x/2, level_size.x/2),
	 Util.RNG.randi_range(-level_size.y/2, level_size.y/2)) * Util.TILE_SIZE

func spawn_loot() -> void:
	var loot : Loot = loot_scene.instantiate()
	loot.global_position = Player.player.global_position
	loot.level = 1
	add_child(loot)
	
func decrement_active_enemy_count() -> void:
	spawn_loot()
	active_enemy_count -= 1
