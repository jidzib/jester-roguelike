extends Node

func play(animation_player: AnimationPlayer,
		  _animation_name: String, windup_point: float = 0.0, _windup_duration: float = 0.0,
		  animation_speed: float = 1.0, animation_finished: Variant = null) -> void:
	#animation.play(_direction)
	#animation.animation_finished.connect(despawn)
	animation_player.speed_scale = animation_speed
	animation_player.current_animation = _animation_name
	var windup_time : float = animation_player.current_animation_length * windup_point
	animation_player.play()
	await get_tree().create_timer(windup_time).timeout
	#animation_player.seek(windup_time, true)
	if not animation_player:
		return
	animation_player.pause()
	await get_tree().create_timer(_windup_duration).timeout
	if animation_player:
		animation_player.play()
		await animation_player.animation_finished
		if animation_finished:
			animation_finished.emit()
			animation_player.speed_scale = 1.0
	#queue_free()
