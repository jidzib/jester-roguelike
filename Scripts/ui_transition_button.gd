class_name UITransitionButton extends Button

@export var transition_to : UIManager.UIs


func _on_pressed() -> void:
	UiManager.switch_ui(UiManager.UI_SCENES[transition_to].instantiate())
	#UiManager.switch_ui(transition_to)
