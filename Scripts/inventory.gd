class_name Inventory extends Node2D

@export var parent_stats : Stats

@export var atk_label : Label
@export var def_label : Label
@export var mga_label : Label
@export var mgd_label : Label

@export var item_slot_container : Control
var item_slots : Dictionary[ItemSlot, bool]

@export var close_menu_button : TextureButton

func _ready() -> void:
	parent_stats.updated_combat_stats.connect(update_labels)
	close_menu_button.pressed.connect(hide)
	update_labels()
	init_item_slots()

func init_item_slots() -> void:
	for item_slot : ItemSlot in item_slot_container.get_children():
		item_slots.set(item_slot, true)
		item_slot.update_display()
		item_slot.fill_slot.connect(stats_added)
		item_slot.change_slot.connect(stats_removed)
		if item_slot.item and item_slot.item.combat_stats:
			stats_added(item_slot.item)

func stats_added(item: CharmItem) -> void:
	if item is CharmItem:
		parent_stats.add_combat_stats(item.combat_stats)
func stats_removed(item: CharmItem) -> void:
	if item is CharmItem:
		parent_stats.remove_combat_stats(item.combat_stats)

func update_labels() -> void:
	atk_label.text = str(int(parent_stats.combat_stats.combat_stats[CombatManager.COMBAT_STATS.ATTACK]))
	def_label.text = str(int(parent_stats.combat_stats.combat_stats[CombatManager.COMBAT_STATS.DEFENSE]))
	mga_label.text = str(int(parent_stats.combat_stats.combat_stats[CombatManager.COMBAT_STATS.MAGIC_ATTACK]))
	mgd_label.text = str(int(parent_stats.combat_stats.combat_stats[CombatManager.COMBAT_STATS.MAGIC_DEFENSE]))
