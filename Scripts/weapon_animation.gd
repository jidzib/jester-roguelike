class_name WeaponAnimation extends Node2D

@export var animation_player : AnimationPlayer
@export_range(0.0, 1.0) var windup_point : float = 0.0
#@export var wind_up_duration : float = 0.0
@export var duration : float
@export var animation_path : String = ""

func play(animation_data: AnimationData, playback_speed: float = 1.0) -> void:
	AnimationHelper.play(animation_player, animation_data.direction, animation_data.windup_point,
						 animation_data.windup_duration, playback_speed)


func despawn() -> void:
	queue_free()

#func wait(_signal: Signal) -> void:
	#animation.pause()
	#await _signal
	#animation.play()
