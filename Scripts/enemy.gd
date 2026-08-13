class_name Enemy extends Entity

@export var points_value : int = 1

signal send_points_value(points: int)

func die() -> void:
	send_points_value.emit(points_value)
	super()
