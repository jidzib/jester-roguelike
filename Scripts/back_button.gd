@tool
extends CustomButton

func _ready() -> void:
	super()
	pressed.connect(UiManager.remove_ui)
	
