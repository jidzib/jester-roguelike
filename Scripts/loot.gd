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
	print("OPENING BAG")
	var ui : LootScreen = UiManager.UI_SCENES[UiManager.UIs.LOOT_SCREEN].instantiate()
	ui.save_inventory.connect(reassign_items)
	ui.initialize(items)
	UiManager.switch_ui(ui)
	UiManager.pause_game()
	pass # OPEN INVENTORY UI FOR LOOT BAG AND PLAYER

func reassign_items(_items: Array[Item]) -> void:
	items = _items
