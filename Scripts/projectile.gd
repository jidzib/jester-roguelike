class_name Projectile extends Node2D

@export var hit_effect : Enums.HitEffects
@export var item_source : Enums.Items
@export var hitbox_size : Vector2i

@export var lifetime : float
var time_alive : float = 0.0

signal charged

@export var speed : float
var direction : Vector2
@export var slow_multiplier : float

@export var sprite : Sprite2D
@export var animation_player : AnimationPlayer
var hitbox : Hitbox

@export var cast_sound : AudioStream

func _ready() -> void:
	
	hitbox.landed_hit.connect(_on_hurtbox_landed_hit)
	sprite.rotation = atan2(direction.y, direction.x)
	var original_speed : float = speed
	speed *= slow_multiplier
	charge()
	add_child(hitbox)
	AudioManager.play_randomized_sound(cast_sound)
	await charged
	speed = original_speed
	animation_player.play("fly")
	
func _process(delta: float) -> void:
	time_alive += delta
	if time_alive >= lifetime:
		_despawn()

func _despawn() -> void:
	queue_free()

func initialize(_parent_stats: Stats, _spawn_hitbox: bool = true) -> void:
	if not _spawn_hitbox:
		return
	var shape : Shape2D = RectangleShape2D.new()
	shape.size = hitbox_size
	hitbox = Hitbox.new(_parent_stats, lifetime, shape, 
						References.HIT_EFFECTS[hit_effect],
	 					References.ITEMS[item_source])

func charge() -> void:
	pass
	#animation_player.play("charging")
	#await get_tree().create_timer(0.4).timeout
	#charged.emit()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_hurtbox_landed_hit(entry: Stats) -> void:
	pass
	#set_physics_process(false)
	#animation_player.play("explode")
	#await get_tree().create_timer(0.45).timeout
	#queue_free()
