class_name LootScreen extends UI

signal save_inventory(_items: Array[Item])

var item_slots : Array[ItemSlot] = []
@export var items_container : HBoxContainer

@export var close_button : TextureButton

func _ready() -> void:
	close_button.pressed.connect(close)

func close() -> void:
	
	#var items : Array[Item] = []
	#for item_slot in item_slots:
		#items.append(item_slot.item)
	#save_inventory.emit(items)
	closed.emit()
	UiManager.remove_ui()
	if Player.player:
		Player.player.in_menu = false
	#queue_free()

func initialize(_items: Array[Item]) -> void:
	for item in _items:
		var item_slot : ItemSlot = load("uid://bwetdj5om0tm").instantiate()
		item_slot.item = item
		items_container.add_child(item_slot)
		item_slots.append(item_slot)
