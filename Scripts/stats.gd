class_name Stats extends Node

signal lose_hp
signal gain_hp

signal update_hp(new_amount : int)
signal update_mana(new_amount : int)

@export var max_hp : int
var current_hp : int :
	set(hp):
		current_hp = hp
		update_hp.emit(hp)
		
@export var max_mana : int
var current_mana : int

# COMBAT
enum COMBAT_STATS {
	PHYSICAL_ATTACK,
	DEFENSE,
	MAGIC_POWER
}
@export var combat_stats : Dictionary[COMBAT_STATS, float] = {
	COMBAT_STATS.PHYSICAL_ATTACK : 1.0,
	COMBAT_STATS.DEFENSE : 1.0,
	COMBAT_STATS.MAGIC_POWER : 1.0,
}

func get_physical_attack() -> float:
	return combat_stats[COMBAT_STATS.PHYSICAL_ATTACK]
func set_physical_attack(new_value: float) -> void:
	combat_stats[COMBAT_STATS.PHYSICAL_ATTACK] = new_value
func get_defense() -> float:
	return combat_stats[COMBAT_STATS.DEFENSE]
func set_defense(new_value: float) -> void:
	combat_stats[COMBAT_STATS.DEFENSE] = new_value
func get_magic_power() -> float:
	return combat_stats[COMBAT_STATS.MAGIC_POWER]
func set_magic_power(new_value: float) -> void:
	combat_stats[COMBAT_STATS.MAGIC_POWER] = new_value

@export var team : Enums.Teams

func _ready() -> void:
	current_hp = max_hp
	current_mana = max_mana

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
