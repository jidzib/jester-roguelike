class_name AnimationData extends Resource

@export var windup_point : float
@export var windup_duration : float
@export var direction : String

func _init(_windup_point: float = 0.0, _windup_duration: float = 0.0, _direction: String = "") -> void:
	windup_point = _windup_point
	windup_duration = _windup_duration
	direction = _direction
