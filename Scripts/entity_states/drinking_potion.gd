extends State

@export var idle_state : State

func enter() -> void:
	parent.current_state = parent.States.DRINKING_POTION
	parent.action_locked = true
	parent.speed /= 2
	await get_tree().create_timer(0.5).timeout
	parent.change_state(idle_state)
	
func exit() -> void:
	parent.action_locked = false
	parent.speed *= 2
	
