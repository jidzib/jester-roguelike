class_name Loot extends TextureButton

@export var level : int = 1

var items : Array[Item] = []

var atlas_regions : Dictionary[String, Rect2] = {
	"open" : Rect2(0.0, 0.0, 32.0, 32.0),
	"closed" : Rect2(32.0, 0.0, 32.0, 32.0)
}

func _ready() -> void:
	set_region("closed")
	initialize_loot()

func initialize_loot() -> void:
	Items.build_rarity_pools() # LOWKEY INEFFICIENT CALLING THIS ON EACH LOOT BUT IS CHILL
	
	var selected_loot : Dictionary[Item, bool] = {}
	for i in range(level):
		var rand : float = Util.RNG.randf_range(0.0, 1.0)
		var pool_id : Items.RARITY
		if rand <= 0.5:
			#COMMON
			pool_id = Items.RARITY.COMMON
		elif rand <= 0.8:
			# UNCOMMON
			pool_id = Items.RARITY.UNCOMMON
		elif rand <= 0.95: # rand <= 1.0
			# RARE
			pool_id = Items.RARITY.RARE
		elif rand <= 1.0:
			pool_id = Items.RARITY.EPIC
			
		var item : Item = pick_from_pool(pool_id)
		if item not in selected_loot:
			items.append(item)
			if item is not PotionItem:
				selected_loot.set(item, true)

func pick_from_pool(pool_id: Items.RARITY) -> Item:
	var pool : Array = Items.rarity_pools[pool_id]
	return References.ITEMS[pool.pick_random()]

func set_region(str: String) -> void:
	texture_normal.region = atlas_regions[str]
	
func _on_pressed() -> void:
	print("pressed bag")
	if not player_in_range():
		return
	set_region("open")
	var ui : LootScreen = UiManager.UI_SCENES[UiManager.UIs.LOOT_SCREEN].instantiate()
	ui.save_inventory.connect(reassign_items)
	ui.initialize(items)
	UiManager.switch_ui(ui)
	ui.closed.connect(queue_free)
	pass # OPEN INVENTORY UI FOR LOOT BAG AND PLAYER

func player_in_range() -> bool:
	if bag_pos().distance_to(Player.player.center.global_position) <= 60.0:
		return true
	return false

func bag_pos() -> Vector2:
	return global_position + pivot_offset
	
func reassign_items(_items: Array[Item]) -> void:
	items = _items
