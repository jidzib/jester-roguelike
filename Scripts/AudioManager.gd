extends Node

var volume : float
var db : float

var min_db : float = -20.0
var max_db : float = 0.0

func set_db():
	if volume <= 0.0:
		db = -80.0
	else:
		db = lerp(min_db, max_db, volume)

func play_sound(sound: AudioStream) -> void:
	var audio_player : AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = sound
	add_child(audio_player)
	audio_player.volume_db = db
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func play_randomized_sound(sound: AudioStream) -> void:
	var audio_player : AudioStreamPlayer = AudioStreamPlayer.new()
	randomize_audio(audio_player)
	audio_player.stream = sound
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func randomize_audio(audio_player: AudioStreamPlayer) -> void:
	audio_player.pitch_scale = Util.RNG.randf_range(0.9, 1.3)
	audio_player.volume_db = db
