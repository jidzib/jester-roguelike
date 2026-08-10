extends State

@export var idle_state : State

var deceleration : float = 200.0

var knockback_strength : float
var knockback_direction : Vector2

func enter() -> void:
	parent.action_locked = true
	parent.movement_locked = true
	parent.hurtbox.disable()
	
func process_physics(delta: float) -> void:
	knockback_strength -= delta * deceleration
	if knockback_strength <= 0:
		parent.change_state(idle_state)
	parent.velocity = lerp(parent.velocity, knockback_direction * knockback_strength, min(knockback_strength * delta, 1.0))
	
func set_knockback(_knockback_strength: float, _knockback_direction: Vector2) -> void:
	knockback_strength = _knockback_strength
	knockback_direction = _knockback_direction

func exit() -> void:
	parent.action_locked = false
	parent.movement_locked = false
	set_knockback(0, Vector2.ZERO)
	parent.hurtbox.enable()
