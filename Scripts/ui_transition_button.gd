@tool
class_name UITransitionButton extends CustomButton

@export var transition_to : UIManager.UIs
@export var label : Label
@export var text : String :
	set(value):
		text = value
		if not label:
			label = Label.new()
			add_child(label)
		label.text = text

func _ready() -> void:
	super()

func connect_signals() -> void:
	super()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	UiManager.switch_ui(UiManager.UI_SCENES[transition_to].instantiate())
