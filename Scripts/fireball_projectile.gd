class_name FireballProjectile extends Projectile

func charge() -> void:
	animation_player.play("charging")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	charged.emit()

func _on_hurtbox_landed_hit(entry: Stats) -> void:
	set_physics_process(false)
	animation_player.play("explode")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	queue_free()
