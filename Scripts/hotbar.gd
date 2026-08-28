class_name Hotbar extends Node2D

@export var item_slot1 : ItemSlot
@export var item_slot2 : ItemSlot
@export var item_slot3 : ItemSlot
@export var item_slot4 : ItemSlot
@export var item_slot5 : ItemSlot

@export var max_slot : int = 5

var items : Dictionary[int, ItemSlot] = {}
var selected_slot : int = 0

func _ready() -> void:
	items = {
		1 : item_slot1,
		2 : item_slot2,
		3 : item_slot3,
		4 : item_slot4,
		5 : item_slot5
	}
	item_slot1.selected_sprite.visible = true
	for item_slot in items.values():
		item_slot.update_display()
	z_index = -1
	
func add(item: Item) -> void:
	for i in items.keys():
		if items[i].item == null:
			items[i].item = item
			items[i].update_display()
			return

func remove(item: Item) -> void:
	for i in items.keys():
		if items[i].item == item:
			items[i].item = null
			items[i].update_display()
			return

func set_selected(slot: int, player: Player) -> void:
	if slot != selected_slot:
		if selected_slot:
			items[selected_slot].selected = false
			items[selected_slot].update_display()
		items[slot].selected = true
		items[slot].update_display()
		selected_slot = slot
		player.held_item.item_slot = items[selected_slot]

func select_left(player: Player) -> void:
	var new_slot : int = selected_slot-1
	if new_slot == 0:
		new_slot = max_slot
	set_selected(new_slot, player)
	
func select_right(player: Player) -> void:
	var new_slot : int = selected_slot+1
	if new_slot > max_slot:
		new_slot = 1
	set_selected(new_slot, player)
	
