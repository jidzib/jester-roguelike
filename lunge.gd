class_name LungeState extends AttackingState

@export var lunge_multiplier : float = 1.5

var tween : Tween = create_tween()

func enter() -> void:
	super()
	parent.speed = 0.0
	await get_tree().create_timer(windup_duration / animation_speed / 2).timeout
	perform_lunge()

func process_physics(delta: float) -> void:
	parent.velocity = parent.speed * parent.direction
	parent.speed -= delta * lunge_multiplier
func perform_lunge() -> void:
	#tween.tween_property(parent, "speed", original_speed * lunge_multiplier, 0.1)
	parent.speed = original_speed * lunge_multiplier
	#await tween.tween_property(parent, "speed", 0.0, 0.5)
	#parent.speed = original_speed
	
func exit() -> void:
	super()
