class_name PlayButton extends CustomButton

func _ready() -> void:
	super()
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	if Player.player:
		Player.player.queue_free()
	get_tree().root.add_child(load("uid://cq336y4xds2th").instantiate())
	UiManager.clear_ui()
