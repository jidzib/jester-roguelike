extends State

@export var idle_state : State

@export var roll_multiplier : float = 3.0
@export var speed_decay : float = 20
var original_speed : float


func enter() -> void:
	parent.current_state = parent.States.ROLL
	original_speed = parent.speed
	parent.action_locked = true
	parent.hurtbox.disable()
	parent.hit_flash()
	
	parent.animation_player.play(parent.animation_path+"roll")
	roll()
	await parent.animation_player.animation_finished
	parent.change_state(idle_state)

func roll() -> void:
	parent.speed *= roll_multiplier
	var min_roll_speed : float = parent.speed / roll_multiplier
	var tween : Tween = create_tween()
	tween.tween_property(parent, "speed", min_roll_speed, parent.animation_player.current_animation_length)

#func process_physics(delta: float) -> void:
	#parent.speed -= speed_decay / roll_multiplier
	#parent.speed = max(parent.speed, original_speed / roll_multiplier)
	
func exit() -> void:
	parent.speed = original_speed
	parent.action_locked = false
	parent.hurtbox.enable()
