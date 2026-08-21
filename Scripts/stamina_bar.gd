class_name StaminaBar extends Node2D

@export var max_stamina : int = 3
var stamina : float :
	set(value):
		stamina = value
		progress_bar.value = value

@export var regeneration_speed : float = 0.2

@export var progress_bar : TextureProgressBar

func _ready() -> void:
	progress_bar.max_value = max_stamina
	stamina = max_stamina	
	
func _process(delta: float) -> void:
	if stamina < max_stamina:
		stamina += delta * regeneration_speed
		if stamina > max_stamina:
			stamina = max_stamina
