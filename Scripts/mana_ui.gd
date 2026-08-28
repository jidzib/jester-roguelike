extends TextureProgressBar

@export var parent : Player
@export var label : Label

func _ready() -> void:
	max_value = parent.stats.max_mana
	value = parent.stats.max_mana

func update_mana(new_amount : int) -> void:
	value = new_amount
	value = max(value, 0)
	value = min(value, max_value)
	update_label(value)
func update_label(new_value: float) -> void:
	label.text = str(int(new_value)) + "/" + str(int(max_value))

func _on_tree_entered() -> void:
	parent.stats.update_mana.connect(update_mana)
	
func _on_tree_exited() -> void:
	parent.stats.update_mana.disconnect(update_mana)
