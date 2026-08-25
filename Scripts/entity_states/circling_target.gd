extends State


func enter() -> void:
	parent.current_state = parent.States.CIRCLING_TARGET
	
func process_physics(delta: float) -> void:
	var tangent : Vector2 = Vector2(-parent.direction.y, parent.direction.x)
	parent.velocity = lerp(parent.velocity, tangent * parent.speed, min(parent.acceleration * delta, 1.0))

func exit() -> void:
	parent.velocity = Vector2.ZERO
