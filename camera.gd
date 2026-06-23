extends Camera2D

func camera_shake(shake_strength : float, duration : float = 0.05):
	var tween = create_tween()
	
	tween.tween_property(self, "offset", Vector2(-shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(-shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	
