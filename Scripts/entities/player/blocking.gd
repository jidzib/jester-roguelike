class_name BlockingState extends State

@export var idle_state : State

var original_speed : float
var progress : float = 0.0
var duration : float = 0.5

func enter() -> void:
	parent.current_state = parent.States.BLOCKING
	parent.action_locked = true
	progress = 0.0
	original_speed = parent.speed
	parent.speed /= 2
	
	parent.cardinal_direction = parent.get_cardinal_direction(parent.center.global_position.direction_to(parent.get_global_mouse_position()))
	parent.set_facing(parent.cardinal_direction)
	#parent.update_direction("direction", parent.center.global_position.direction_to(parent.get_global_mouse_position()))
	parent.animation_player.play(parent.animation_path+parent.facing+"_block")

func process_frame(delta: float) -> void:
	progress += delta
	if progress > duration:
		parent.change_state(idle_state)
		
func exit() -> void:
	parent.speed = original_speed
	parent.action_locked = false
