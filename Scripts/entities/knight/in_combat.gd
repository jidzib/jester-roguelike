extends State

@export var attacking_state : State

var tangent : Vector2

var circle_threshold : float = 30.0

var attack_cooldown : float = 0.8
var attack_timer : float = 0.0

func enter() -> void:
	parent.current_state = parent.States.IN_COMBAT
	attack_timer = 0.0

func process_frame(delta: float) -> void:
	if attack_timer < attack_cooldown:
		attack_timer += delta
	
func process_physics(delta: float) -> void:
	parent.direction = parent.global_position.direction_to(parent.target.global_position)
	parent.direction = parent.direction.normalized()
	if parent.global_position.distance_to(parent.target.global_position) < circle_threshold:
		if attack_timer > attack_cooldown:
			parent.state_nodes[parent.States.ATTACKING].target = parent.target.global_position
			parent.update_weapon_direction(parent.center.global_position.direction_to(parent.target.center.global_position))
			parent.state_machine.change_state(attacking_state)
		else:	
			parent.label.text = "CIRCLING"
			parent.raycast.modulate = Color.GREEN
			tangent = Vector2(-parent.direction.y, parent.direction.x)
			parent.raycast.target_position = tangent * circle_threshold
			parent.velocity = lerp(parent.velocity, tangent * parent.speed, parent.acceleration * delta)
	else:
		parent.label.text = "CHASING"
		parent.raycast.modulate = Color.BLUE
		parent.raycast.target_position = parent.target.global_position - parent.raycast.global_position
		parent.velocity = lerp(parent.velocity, parent.direction * parent.speed, parent.acceleration * delta)
	
	parent.move_and_slide()
	
