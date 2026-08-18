extends State

signal wind_up_finished

@export var transition_state : State

var progress : float
@export var duration : float = 0.5
@export var wind_up_duration : float = 0.0
var windup_point: float

var original_speed : float
var attack_name : String = ""
var speed_multiplier : float = 0.5

var target_dir : Vector2
	
func initialize(_duration: float, _attack_name: String, _speed_multiplier: float) -> void:
	duration = _duration
	attack_name = _attack_name
	speed_multiplier = _speed_multiplier

func enter() -> void:
	parent.current_state = parent.States.ATTACKING
	parent.action_locked = true
	progress = 0.0
	original_speed = parent.speed
	parent.speed *= speed_multiplier
	
	parent.cardinal_direction = parent.get_cardinal_direction(parent.center.global_position.direction_to(target_dir))
	parent.set_facing(parent.cardinal_direction)
	
	#parent.update_direction("direction", parent.center.global_position.direction_to(target))
	
	AnimationHelper.play(parent.animation_player, parent.animation_path+parent.facing+"_"+attack_name,
	windup_point, wind_up_duration)
	#parent.animation_player.play(parent.animation_path+parent.facing+"_"+attack_name)

func process_frame(delta: float) -> void:
	progress += delta
	if progress > parent.animation_player.current_animation_length * windup_point + wind_up_duration:
		wind_up_finished.emit()
	if progress > duration:
		parent.change_state(transition_state)

func exit() -> void:
	parent.action_locked = false
	parent.speed = original_speed
