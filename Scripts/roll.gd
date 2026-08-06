extends State

@export var idle_state : State

@export var roll_multiplier : float = 4.0
@export var speed_decay : float = 20
var original_speed : float


func enter() -> void:
	parent.current_state = parent.States.ROLL
	original_speed = parent.speed
	parent.speed *= roll_multiplier
	parent.action_locked = true

func process_frame(delta: float) -> void:
	if parent.speed <= original_speed / 4:
		parent.change_state(idle_state)

func process_physics(delta: float) -> void:
	parent.speed -= speed_decay
	
func exit() -> void:
	parent.speed = original_speed
	parent.action_locked = false
