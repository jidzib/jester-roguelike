extends Node

var damage_indicator : PackedScene = load("uid://dvssaggp65nk1")

func spawn_damage_indicator_instance(damage: float, attack_type: CombatManager.COMBAT_STATS, _position: Vector2) -> void:
	var new_damage_indicator : DamageIndicator = damage_indicator.instantiate()
	new_damage_indicator.initialize(damage, attack_type, _position)
	add_child(new_damage_indicator)
	
func play_particle(particles_id: Enums.Particles, pos: Vector2) -> void:
	var particles : GPUParticles2D = References.PARTICLES[particles_id].instantiate()
	particles.global_position = pos
	add_child(particles)
	particles.emitting = true
	particles.z_index = 10
	await particles.finished
	particles.queue_free()
