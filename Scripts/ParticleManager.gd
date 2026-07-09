extends Node

func play_particle(particles_id: Enums.Particles, pos: Vector2) -> void:
	var particles : GPUParticles2D = References.PARTICLES[particles_id].instantiate()
	particles.global_position = pos
	add_child(particles)
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
