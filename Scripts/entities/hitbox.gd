class_name Hitbox extends Area2D

var parent_stats : Stats
var lifetime : float
var shape : Shape2D

func _init(_parent_stats : Stats, _lifetime : float, _shape : Shape2D) -> void:
	parent_stats = _parent_stats
	lifetime = _lifetime
	shape = _shape
	
func _ready() -> void:
	monitorable = false
	#area_entered.connect()
	if lifetime > 0:
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(queue_free)
		timer.call_deferred("start", lifetime)
		
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	# SET MASK DEPENDING ON TEAM

func _area_entered(area: Area2D) -> void:
	if area is not Hurtbox:
		return
	area.receive_hit(parent_stats.attack)
	
#@export var parent : Entity
#
#func hitbox() -> void:
	#pass
#
#func _on_area_entered(area: Area2D) -> void:
	#if area.has_method("hurtbox"):
		#if area.parent:
			#if area.parent == parent:
				#return
			#if parent.is_parried(area.parent, "attack", area.damage):
				#return
		#area.landed_hit.emit() # <- this signal should connect to the player and call their gethit function
		##parent.get_hit(area.damage, area.global_position)
		#parent.stats.take_damage(area.damage)
		#area.particles.emitting = true
		#if area.parent is Player:
			#var hit_strength : float = 1
			#area.parent.camera.camera_shake(hit_strength)
