extends TextureProgressBar

@export var parent : Entity
@export var small_version : bool = false
@export var label : Label

func _ready() -> void:
	max_value = parent.stats.max_hp
	value = parent.stats.max_hp
	parent.stats.update_hp.connect(update_hp)
	if small_version:
		label.hide()
		texture_over = null
	
func update_hp(new_amount : float) -> void:
	if value > new_amount:
		color_flash(Color.RED)
	elif value < new_amount:
		color_flash(Color.GREEN)
	value = new_amount
	value = max(value, 0)
	value = min(value, max_value)
	update_label(value)
	
func color_flash(color: Color, duration: float = 0.5) -> void:
	var original_color : Color = tint_progress
	var tween : Tween = create_tween()
	tween.tween_property(self, "tint_progress", color, duration)
	tween.tween_property(self, "tint_progress", original_color, duration)

func update_label(new_value: float) -> void:
	label.text = str(int(new_value)) + "/" + str(int(max_value))

func _exit_tree() -> void:
	parent.stats.update_hp.disconnect(update_hp)
