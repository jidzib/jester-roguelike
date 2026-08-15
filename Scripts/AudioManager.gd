extends Node

var volume : float
var db : float

var min_db : float = -20.0
var max_db : float = 0.0

enum SOUNDS {
	SWORD_SWING,
	SWORD_HIT,
	PARRY,
	WALKING,
	DRINK_POTION,
	EXPLODE,
	FIREBALL_WOOSH,
	BUTTON_CLICK
}

var AUDIO_FILES : Dictionary[SOUNDS, AudioStream] = {
	SOUNDS.SWORD_SWING : preload("uid://byiiu3ajioyex"),
	SOUNDS.SWORD_HIT : preload("uid://ecah47igkrxn"),
	SOUNDS.PARRY : preload("uid://dmfwakpfokgd0"),
	SOUNDS.WALKING : preload("uid://ts6wxxih155f"),
	SOUNDS.DRINK_POTION : preload("uid://d4kpctvqt1o08"),
	SOUNDS.EXPLODE : preload("uid://dciqrjwbluctj"),
	SOUNDS.FIREBALL_WOOSH : preload("uid://b10ori3v8riky"),
	SOUNDS.BUTTON_CLICK : preload("uid://bkbjt3sykxbfw")
	
}
	
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

func play_randomized_sound_id(id: SOUNDS) -> void:
	play_randomized_sound(AUDIO_FILES[id])

func randomize_audio(audio_player: AudioStreamPlayer) -> void:
	audio_player.pitch_scale = Util.RNG.randf_range(0.9, 1.3)
	audio_player.volume_db = db
