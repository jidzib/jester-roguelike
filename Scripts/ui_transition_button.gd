@tool
class_name UITransitionButton extends TextureButton

@export var transition_to : UIManager.UIs
@export var label : Label
@export var text : String :
	set(value):
		text = value
		label.text = text

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	UiManager.switch_ui(UiManager.UI_SCENES[transition_to].instantiate())
	#UiManager.switch_ui(transition_to)
