class_name Hitbox extends Area2D

signal landed_hit(target: Stats)
var hitlog : Dictionary[Stats, bool]


var parent_stats : Stats
var lifetime : float
var shape : Shape2D

var hit_effect : HitEffect
var source_item : Item

func _init(_parent_stats : Stats, _lifetime : float, _shape : Shape2D, _hit_effect : HitEffect, _source_item: Item) -> void:
	parent_stats = _parent_stats
	lifetime = _lifetime
	shape = _shape
	hit_effect = _hit_effect
	source_item = _source_item
	
func _ready() -> void:
	monitorable = false
	area_entered.connect(_area_entered)
	landed_hit.connect(update_hitlog)
	
	if lifetime > 0:
		var timer = Timer.new()
		add_child(timer)
		timer.timeout.connect(queue_free)
		timer.start(lifetime)
		timer.call_deferred("start", lifetime)
		
	if shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
	
	# DISABLE THIS NODE FROM BEING DETECTED
	set_collision_layer_value(1, false)
	
	# SET NODE TO HIT EVERY TEAM, THEN DISABLE HITTING OWN TEAM
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	set_collision_mask_value(parent_stats.team, false)

func is_new_hit(entry: Stats) -> bool:
	if entry in hitlog:
		return false
	return true

func update_hitlog(entry: Stats) -> void:
	hitlog.set(entry, true)

func emit_effects() -> void:
	hit_effect.emit(global_position) 
	
func _area_entered(area: Area2D) -> void:
	if area is not Hurtbox:
		return
	if not is_new_hit(area.parent_stats):
		return
	emit_effects()
	if area.is_blocking():
		area.parry_hit_effect.emit(global_position)
		return
	# spawn particles, and/or send signal of successful attack
	landed_hit.emit(area.parent_stats)
	area.receive_hit(parent_stats, source_item, global_position.direction_to(area.global_position))
