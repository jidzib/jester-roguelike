class_name Game extends Node2D

@export var settings : Settings

func _ready() -> void:
	if settings:
		settings.queue_free()
