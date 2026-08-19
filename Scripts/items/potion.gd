class_name PotionItem extends Item

var drink_sound : AudioStream = load("uid://d4kpctvqt1o08")
@export var restore_amount : float

func use(entity: Entity, target_dir: Vector2) -> void:
	AudioManager.play_randomized_sound(drink_sound)
