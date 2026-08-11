class_name WeaponAnimation extends Node2D

@export var animation_player : AnimationPlayer
@export_range(0.0, 1.0) var windup_point : float = 0.0
#@export var wind_up_duration : float = 0.0
@export var duration : float

signal animation_finished

func play(_direction: String, _windup_duration: float = 0.0) -> void:
	animation_finished.connect(despawn)
	AnimationHelper.play(animation_player, _direction, windup_point, _windup_duration, animation_finished)
	
func despawn() -> void:
	animation_finished.disconnect(despawn)
	queue_free()

#func wait(_signal: Signal) -> void:
	#animation.pause()
	#await _signal
	#animation.play()
