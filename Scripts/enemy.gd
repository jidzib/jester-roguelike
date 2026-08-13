class_name Enemy extends Entity

@export var points_value : int = 1

signal send_points_value(points: int)

#func _ready() -> void:
	#target.player_died.connect(queue_free)

func die() -> void:
	send_points_value.emit(points_value)
	super()
