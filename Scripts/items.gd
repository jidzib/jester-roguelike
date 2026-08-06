class_name Items

enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

static var rarity_pools = {}

static func build_rarity_pools() -> void:
	rarity_pools.clear()
	for id in References.ITEMS:
		if References.ITEMS[id].rarity not in rarity_pools:
			rarity_pools.set(References.ITEMS[id].rarity, [])
		rarity_pools[References.ITEMS[id].rarity].append(id)
