extends ProgressBar

@export var parent : Player

func _ready() -> void:
	max_value = parent.max_mana
	value = parent.max_mana

func gain_mana(amount : int) -> void:
	value += amount
	
func lose_mana(amount : int) -> void:
	value -= amount

func _on_tree_entered() -> void:
	parent.gain_mana.connect(gain_mana)
	parent.lose_mana.connect(lose_mana)
	
func _on_tree_exited() -> void:
	parent.gain_mana.disconnect(gain_mana)
	parent.lose_mana.disconnect(lose_mana)
