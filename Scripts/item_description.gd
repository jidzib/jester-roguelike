class_name ItemDescription extends Node2D

@export var label : RichTextLabel
@export var back : NinePatchRect
@export var item_slot : ItemSlot

func _ready() -> void:
	item_slot.fill_slot.connect(update_description_box)
	update_description_box(item_slot.item)
	
func update_description_box(item: Item) -> void:
	position = Vector2.ZERO
	if item:
		set_text(item)
		set_position_and_size()

func set_position_and_size() -> void:
	var width : float = get_label_width()
	var height : float = get_label_height()
	set_back_size(width, height)
	position = Vector2(-width / 2 + item_slot.size.x/2, -height - item_slot.size.y)
	
func set_text(item: Item) -> void:
	var data : Dictionary = {
		"name" : get_item_name(item),
		"description" : get_item_description(item),
		"rarity_color" : get_item_rarity_color(item),
		"rarity_name" : get_item_rarity_name(item)
	}
	label.text = "[b]{name}[/b]".format(data)
	label.text += "\n[font_size=4][color={rarity_color}]{rarity_name}[/color][/font_size]".format(data)
	label.text += "\n{description}".format(data)
	if item_is_charm(item):
		label.text += "\n" + combat_stats_as_string(item.combat_stats)
	if item_is_weapon(item):
		label.text += "\n" + item_power_as_string(item)
	if item_is_potion(item):
		label.text += "\n" + potion_restore_as_string(item)
	if item_is_spellbook(item):
		label.text += "\n" + spellbook_mana_cost_string(item)
func get_item_name(item: Item) -> String:
	return item.name
func get_item_description(item: Item) -> String:
	return item.description
func get_item_rarity_name(item: Item) -> String:
	return Items.RARITY.keys()[item.rarity]
func get_item_rarity_color(item: Item) -> String:
	return Items.COLOR_FROM_RARITY[item.rarity].to_html(true)
func item_is_charm(item: Item) -> bool:
	return item is CharmItem
func get_item_combat_stats(item: CharmItem) -> CombatStats:
	return item.combat_stats
func combat_stats_as_string(stats: CombatStats) -> String:
	var string : String = ""
	for stat in stats.combat_stats:
		var data : Dictionary = display_data[stat]
		data.set("stat_string", CombatManager.COMBAT_STATS.find_key(stat))
		data.set("value_string", str(stats.combat_stats[stat]))
		string += "{icon} {color_open}{stat_string}[/color] [b]|[/b] {color_open}{value_string}[/color]\n".format(data)
	string.left(-2)
	return string
func item_is_weapon(item: Item) -> bool:
	return item is WeaponItem
func item_power_as_string(item: WeaponItem) -> String:
	var string : String = ""
	var data : Dictionary = display_data[item.ATTACK_TYPE]
	data.set("stat_string", CombatManager.COMBAT_STATS.find_key(item.ATTACK_TYPE))
	data.set("value_string", str(item.power))
	string = "{icon} {color_open}{stat_string}[/color]\n+{value_string} Power".format(data)
	return string

func get_label_height() -> float:
	return label.get_content_height()
func get_label_width() -> float:
	return label.get_content_width()
func set_back_size(_width: float, _height: float, padding: Vector2 = Vector2(20.0, 20.0)) -> void:
	back.size = Vector2(_width, _height) + padding
func item_is_potion(item: Item) -> bool:
	return item is PotionItem
func potion_restore_as_string(item: PotionItem) -> String:
	return "Restores " + str(int(item.restore_amount))
func item_is_spellbook(item: Item) -> bool:
	return item is SpellbookItem
func spellbook_mana_cost_string(item: SpellbookItem) -> String:
	return "Mana Cost: " +  "[color=blue]" + str(int(item.mana_cost)) + "[/color]"
var display_data : Dictionary[CombatManager.COMBAT_STATS, Dictionary] = {
	CombatManager.COMBAT_STATS.ATTACK : {
		"icon" : "[img]uid://cv8a6hg1gnrly[/img]",
		"color_open" : "[color=RED]"
	},
	CombatManager.COMBAT_STATS.DEFENSE : {
		"icon" : "[img]uid://dbkj74lnick16[/img]",
		"color_open" : "[color=GREEN]"
	},
	CombatManager.COMBAT_STATS.MAGIC_ATTACK : {
		"icon" : "[img]uid://rklefs6hup04[/img]",
		"color_open" : "[color=PURPLE]"
	},
	CombatManager.COMBAT_STATS.MAGIC_DEFENSE : {
		"icon" : "[img]uid://ctaxu5f6pop5l[/img]",
		"color_open" : "[color=PINK]"
	},
}
