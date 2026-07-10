extends TextureButton

var items : Array[Item] = []

var num_items : int = 5

func _ready() -> void:
	#var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	for i in range(num_items):
		var rand : int = Util.RNG.randi_range(0, Enums.Items.size())
		var item : Item
		if rand == Enums.Items.size():
			item = null
		else:
			item = References.ITEMS[rand]
		items.append(item)

func _on_pressed() -> void:
	if not player_in_range():
		return
	var ui : LootScreen = UiManager.UI_SCENES[UiManager.UIs.LOOT_SCREEN].instantiate()
	ui.save_inventory.connect(reassign_items)
	ui.initialize(items)
	UiManager.switch_ui(ui)
	UiManager.pause_game()
	pass # OPEN INVENTORY UI FOR LOOT BAG AND PLAYER

func player_in_range() -> bool:
	if bag_pos().distance_to(Player.player.center.global_position) <= 60.0:
		return true
	return false

func bag_pos() -> Vector2:
	return global_position + pivot_offset
	
func reassign_items(_items: Array[Item]) -> void:
	items = _items
