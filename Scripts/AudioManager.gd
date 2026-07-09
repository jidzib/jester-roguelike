extends Node

func play_sound(sound: AudioStream) -> void:
	var audio_player : AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = sound
	add_child(audio_player)
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
	audio_player.volume_db = Util.RNG.randf_range(-2.0, -1.0)
