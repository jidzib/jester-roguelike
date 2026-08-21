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


#const K_PHYSICAL = 20; // tune once, keep fixed across the whole game
#
#function computeDamage(attacker, defender, defenseKey) {
  #const attack = attacker.attack; // or magicAttack via your dictionary
  #const defense = defender[defenseKey];
  #const mitigation = K_PHYSICAL / (K_PHYSICAL + defense);
  #return attacker.weaponDmg * attack * mitigation;
#}

static var K : float = 50
static var DAMAGE_SCALE : float = 0.1

static func damage_calculation(attacker_stats: Stats, defender_stats: Stats, item: WeaponItem) -> float:
	var attack_type : COMBAT_STATS = item.ATTACK_TYPE
	var defense_type : COMBAT_STATS = ATTACK_TO_DEFENSE[attack_type]
	var attack_power : float = attacker_stats.combat_stats.combat_stats[attack_type]
	var defense_power : float = defender_stats.combat_stats.combat_stats[defense_type]
	return item.power * attack_power * (K / (K + defense_power)) * DAMAGE_SCALE

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
