class_name CombatManager

enum COMBAT_STATS {
	ATTACK,
	DEFENSE,
	MAGIC_ATTACK,
	MAGIC_DEFENSE
}

static var ATTACK_TO_DEFENSE : Dictionary[COMBAT_STATS, COMBAT_STATS] = {
	COMBAT_STATS.ATTACK : COMBAT_STATS.DEFENSE,
	COMBAT_STATS.DEFENSE : COMBAT_STATS.DEFENSE,
	COMBAT_STATS.MAGIC_ATTACK : COMBAT_STATS.MAGIC_DEFENSE,
	COMBAT_STATS.MAGIC_DEFENSE : COMBAT_STATS.MAGIC_DEFENSE
}


static func calculate_damage(attacker_stats: Stats, defender_stats: Stats, item: WeaponItem) -> float:
	return apply_defenses(calculate_raw_damage(attacker_stats, item), item.ATTACK_TYPE, defender_stats)
static func calculate_raw_damage(attacker_stats: Stats, item: WeaponItem) -> float:
	var attack_type : COMBAT_STATS = item.ATTACK_TYPE
	var user_attack_power : float = attacker_stats.combat_stats.combat_stats[attack_type]
	return user_attack_power + item.power
static func apply_defenses(raw_damage: float, attack_type: COMBAT_STATS, defender_stats: Stats) -> float:
	var defense_type : COMBAT_STATS = ATTACK_TO_DEFENSE[attack_type]
	var defense_power : float = defender_stats.combat_stats.combat_stats[defense_type]
	return max(1.0, raw_damage - defense_power)
