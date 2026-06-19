class_name Hitbox extends Area2D

@export var parent : Entity

func hitbox() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("hurtbox"):
		if area.parent:
			if area.parent == parent:
				return
			if parent.is_parried(area.parent, "attack", area.damage):
				return
		area.landed_hit.emit()
		parent.get_hit(area.damage, area.global_position)
