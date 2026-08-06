class_name QuitButton extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	get_tree().quit()
