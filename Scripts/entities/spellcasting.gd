extends State

@export var idle_state : State
var duration : float

func enter() -> void:
	parent.current_state = parent.States.SPELLCASTING
	parent.speed /= 4
	parent.action_locked = true
func set_duration(_duration: float) -> void:
	duration = _duration
func start_timer() -> void:
	await get_tree().create_timer(duration).timeout
	parent.change_state(idle_state)
func exit() -> void:
	parent.speed *= 4
	parent.action_locked = false
