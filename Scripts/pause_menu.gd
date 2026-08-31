extends UI

func _ready() -> void:
	UiManager.pause_game()

func close() -> void:
	UiManager.resume_game()
