@tool
class_name UITransitionButton extends CustomButton

@export var transition_to : UIManager.UIs

func _ready() -> void:
	super()

func connect_signals() -> void:
	super()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	#UiManager.switch_ui(UiManager.UI_SCENES[transition_to].instantiate())
	UiManager.add_ui(UiManager.UI_SCENES[transition_to].instantiate())
