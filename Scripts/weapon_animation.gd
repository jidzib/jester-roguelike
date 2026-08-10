class_name WeaponAnimation extends Node2D

@export var animation_player : AnimationPlayer
@export_range(0.0, 1.0) var windup_point : float = 0.0
#@export var wind_up_duration : float = 0.0
@export var duration : float

signal animation_finished

func play(_direction: String, _windup_duration: float = 0.0) -> void:
	animation_finished.connect(despawn)
	AnimationHelper.play(animation_player, _direction, windup_point, _windup_duration, animation_finished)
	##animation.play(_direction)
	##animation.animation_finished.connect(despawn)
	#animation_player.current_animation = _direction
	#var windup_time : float = animation_player.current_animation_length * windup_point
	#animation_player.play()
	#animation_player.seek(windup_time, true)
	#animation_player.pause()
	#await get_tree().create_timer(_windup_duration).timeout
	#animation_player.play()
	#await animation_player.animation_finished
	#queue_free()
	#print("SPAWN ANIMATION")
	
func despawn() -> void:
	animation_finished.disconnect(despawn)
	queue_free()

#func wait(_signal: Signal) -> void:
	#animation.pause()
	#await _signal
	#animation.play()
