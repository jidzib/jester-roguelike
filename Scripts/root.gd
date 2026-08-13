extends Node2D

# NODES FOR INITIALIZING
@export var settings : Settings

func _ready() -> void:
	settings.queue_free()
