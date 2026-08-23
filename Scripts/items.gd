class_name Items

enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHIC
}

static var COLOR_FROM_RARITY : Dictionary[RARITY, Color] = {
	RARITY.COMMON : Color.GRAY,
	RARITY.UNCOMMON : Color.GREEN,
	RARITY.RARE : Color.BLUE,
	RARITY.EPIC : Color.PURPLE,
	RARITY.LEGENDARY : Color.GOLD,
	RARITY.MYTHIC : Color.RED
}

static var rarity_pools = {}

static func build_rarity_pools() -> void:
	rarity_pools.clear()
	for id in References.ITEMS:
		if References.ITEMS[id].rarity not in rarity_pools:
			rarity_pools.set(References.ITEMS[id].rarity, [])
		rarity_pools[References.ITEMS[id].rarity].append(id)
