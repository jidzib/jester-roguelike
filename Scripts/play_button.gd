class_name PlayButton extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	get_tree().root.add_child(load("uid://cq336y4xds2th").instantiate())
	UiManager.clear_ui()
