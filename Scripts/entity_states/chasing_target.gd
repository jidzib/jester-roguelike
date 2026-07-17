extends State

func enter() -> void:
	parent.current_state = parent.States.CHASING_TARGET

func process_physics(delta: float) -> void:
	parent.direction = parent.global_position.direction_to(parent.target.global_position)
	parent.direction = parent.direction.normalized()
	parent.velocity = lerp(parent.velocity, parent.direction * parent.speed, parent.acceleration * delta)
	
	#parent.label.text = "CHASING"
		#parent.raycast.modulate = Color.BLUE
		#parent.raycast.target_position = parent.target.global_position - parent.raycast.global_position
		#parent.velocity = lerp(parent.velocity, parent.direction * parent.speed, parent.acceleration * delta)
