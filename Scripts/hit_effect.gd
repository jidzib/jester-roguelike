class_name HitEffect extends Resource

@export var audio : AudioStream
@export var particles_id : Enums.Particles

func emit(pos: Vector2) -> void:
	if audio:
		AudioManager.play_randomized_sound(audio)
	if particles_id != Enums.Particles.NONE:
		ParticleManager.play_particle(particles_id, pos)
