class_name Camera extends Camera2D

static var camera : Camera

func _ready():
	camera = self

func camera_shake(shake_strength : float, duration : float = 0.05):
	var tween = create_tween()
	shake_strength *= 2
	tween.tween_property(self, "offset", Vector2(-shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(-shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	
