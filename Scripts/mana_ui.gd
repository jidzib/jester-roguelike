extends TextureProgressBar

@export var parent : Player

func _ready() -> void:
	max_value = parent.stats.max_mana
	value = parent.stats.max_mana

func update_mana(new_amount : int) -> void:
	value = new_amount
	value = max(value, 0)
	value = min(value, max_value)

#func gain_mana(amount : int) -> void:
	#value += amount
	#
#func lose_mana(amount : int) -> void:
	#value -= amount

func _on_tree_entered() -> void:
	parent.stats.update_mana.connect(update_mana)
	
func _on_tree_exited() -> void:
	parent.stats.update_mana.disconnect(update_mana)
