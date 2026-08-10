class_name Camera extends Camera2D

static var camera : Camera

func _ready():
	camera = self

func screen_flash(color: Color) -> void:
	var size : Vector2 = get_viewport_rect().size
	var screen_overlay : ColorRect = ColorRect.new()
	screen_overlay.color = color
	screen_overlay.color.a = 0.2
	screen_overlay.size = size
	screen_overlay.position -= size/2
	screen_overlay.z_index = 100
	camera.add_child(screen_overlay)
	await get_tree().create_timer(0.5).timeout
	screen_overlay.queue_free()

func camera_shake(shake_strength : float, duration : float = 0.05):
	var tween = create_tween()
	shake_strength *= 2
	tween.tween_property(self, "offset", Vector2(-shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	tween.tween_property(self, "offset", Vector2(shake_strength, -shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(-shake_strength, shake_strength), duration)
	tween.tween_property(self, "offset", Vector2(), duration)
	
