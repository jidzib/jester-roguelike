class_name AttackingState extends State

signal wind_up_finished

@export var transition_state : State

var progress : float
var duration : float
@export var windup_duration : float = 0.0
var windup_point: float

var original_speed : float
var attack_name : String = ""
var slow_effect : float = 0.5

var animation_speed : float

var target_dir : Vector2
	
func initialize(_animation_data: AnimationData, _duration: float,
				_attack_name: String, _slow_effect: float, _animation_speed: float,
				_weapon_animation: WeaponAnimation) -> void:
	duration = _duration
	attack_name = _attack_name
	windup_point = _animation_data.windup_point
	slow_effect = _slow_effect
	animation_speed = _animation_speed
	attack_finished.connect(_weapon_animation.despawn)

func enter() -> void:
	parent.current_state = parent.States.ATTACKING
	parent.action_locked = true
	progress = 0.0
	original_speed = parent.speed
	parent.speed *= slow_effect
	
	parent.cardinal_direction = parent.get_cardinal_direction(parent.center.global_position.direction_to(target_dir))
	parent.set_facing(parent.cardinal_direction)

	AnimationHelper.play(parent.animation_player, parent.animation_path+parent.facing+"_"+attack_name,
	windup_point, windup_duration, animation_speed)


func process_frame(delta: float) -> void:
	progress += delta
	if progress > parent.animation_player.current_animation_length * windup_point + windup_duration:
		wind_up_finished.emit()
	if progress > duration:
		parent.change_state(transition_state)


signal attack_finished
func exit() -> void:
	parent.held_item.animation_done()
	parent.action_locked = false
	parent.speed = original_speed
	attack_finished.emit()
