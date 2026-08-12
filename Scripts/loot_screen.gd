class_name LootScreen extends UI

signal save_inventory(_items: Array[Item])

var item_slots : Array[ItemSlot] = []
@export var items_container : HBoxContainer
@export var color_rect : ColorRect



func close() -> void:
	var items : Array[Item] = []
	for item_slot in item_slots:
		items.append(item_slot.item)
	save_inventory.emit(items)
	closed.emit()
	pass

func initialize(_items: Array[Item]) -> void:
	for item in _items:
		var item_slot : ItemSlot = load("uid://bwetdj5om0tm").instantiate()
		item_slot.item = item
		items_container.add_child(item_slot)
		item_slots.append(item_slot)
	color_rect.size.x = item_slots.size() * 20.0
