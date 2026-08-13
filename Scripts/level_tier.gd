class_name LevelTier extends Resource

enum LevelTiers {
	EASY,
	MEDIUM,
	HARD,
	EXTREME
}

@export_range(0, 4) var level_difficulty : int = 0
@export var enemy_count_range : Vector2i :
	set(value):
		if value.x >= 0:
			enemy_count_range.x = value.x
		if value.y >= 0:
			enemy_count_range.y = value.y
			
@export var enemy_pool : Dictionary[Enums.Enemies, bool]

@export var loot_tier : int = 1
