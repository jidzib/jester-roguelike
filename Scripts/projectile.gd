class_name Projectile extends Node2D

signal charged

@export var sprite : Sprite2D
@export var animation_player : AnimationPlayer
var hitbox : Hitbox

@export var base_damage : int :
	set(value):
		base_damage = value
		
@export var knockback : float
@export var lifetime : float
var time_alive : float = 0.0

@export var speed : float
var real_speed : float
var direction : Vector2 = Vector2(1.0, 0.0)

@export var cast_sound : AudioStream

func _ready() -> void:
	
	hitbox.landed_hit.connect(_on_hurtbox_landed_hit)
	sprite.rotation = atan2(direction.y, direction.x)
	real_speed = speed
	speed /= 4
	charge()
	add_child(hitbox)
	AudioManager.play_randomized_sound(cast_sound)
	await charged
	speed = real_speed
	animation_player.play("fly")
	
func _process(delta: float) -> void:
	time_alive += delta
	if time_alive >= lifetime:
		_despawn()

func _despawn() -> void:
	queue_free()

func initialize(_parent_stats: Stats) -> void:
	var shape : Shape2D = RectangleShape2D.new()
	shape.size = Vector2(8, 8)
	hitbox = Hitbox.new(_parent_stats, lifetime, shape, 
						References.HIT_EFFECTS[Enums.HitEffects.FIREBALL_HIT],
	 					References.ITEMS[Enums.Items.SPELLBOOK])
	
func init_hitbox(_packed_hitbox: PackedScene) -> void:
	hitbox = _packed_hitbox.instantiate()
	add_child(hitbox)
	
func charge() -> void:
	animation_player.play("charging")
	await get_tree().create_timer(0.4).timeout
	charged.emit()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_hurtbox_landed_hit(entry: Stats) -> void:
	set_physics_process(false)
	animation_player.play("explode")
	await get_tree().create_timer(0.45).timeout
	queue_free()
