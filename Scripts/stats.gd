class_name Stats extends Node

signal update_hp(new_amount : int)
signal update_mana(new_amount : int)

@export var max_hp : int
var current_hp : int :
	set(hp):
		current_hp = hp
		update_hp.emit(hp)
		
@export var max_mana : int
var current_mana : int

@export var base_combat_stats : CombatStats
var combat_stats : CombatStats = CombatStats.new() # <- use this in dmg calc
var added_stats : Dictionary[CombatStats, bool] = {}

signal updated_combat_stats

func reset_combat_stats() -> void:
	for stat in combat_stats.combat_stats:
		combat_stats.combat_stats[stat] = base_combat_stats.combat_stats[stat]
func add_combat_stats(_new_stats: CombatStats) -> void:
	for stat in _new_stats.combat_stats:
		combat_stats.combat_stats[stat] += _new_stats.combat_stats[stat]
	updated_combat_stats.emit()
func remove_combat_stats(_stats_to_remove: CombatStats) -> void:
	for stat in _stats_to_remove.combat_stats:
		combat_stats.combat_stats[stat] -= _stats_to_remove.combat_stats[stat]
	updated_combat_stats.emit()

@export var team : Enums.Teams

func _ready() -> void:
	current_hp = max_hp
	current_mana = max_mana
	reset_combat_stats()
	#update_combat_stats()
	#updated_combat_stats.connect(update_combat_stats)
	
func heal(amount : int) -> void:
	current_hp = min(current_hp+amount, max_hp)
func take_damage(damage : int) -> void:
	current_hp -= damage
	if current_hp <= 0:
		pass # DIE
	
func has_enough_mana(cost : int) -> bool:
	if cost > current_mana:
		return false
	return true
func restore_mana(amount : int) -> void:
	current_mana = min(current_mana + amount, max_mana)
	update_mana.emit(current_mana)
func use_mana(cost : int) -> void:
	current_mana -= cost
	update_mana.emit(current_mana)
