class_name Projectile extends Node2D

signal charged

@export var sprite : Sprite2D
@export var animation_player : AnimationPlayer
@export var hurtbox : Hurtbox

@export var base_damage : int :
	set(value):
		base_damage = value
		
@export var knockback : float
@export var max_range : float

@export var speed : float
var real_speed : float
var direction : Vector2 = Vector2(1.0, 0.0)
var distance_traveled : float

func _ready() -> void:
	hurtbox.damage = base_damage
	distance_traveled = 0.0
	sprite.rotation = atan2(direction.y, direction.x)
	real_speed = speed
	speed /= 4
	charge()
	await charged
	speed = real_speed
	animation_player.play("fly")
	
func charge() -> void:
	animation_player.play("charging")
	await get_tree().create_timer(0.4).timeout
	charged.emit()
	

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	distance_traveled += Vector2.ZERO.distance_to(direction * speed * delta)
	if distance_traveled > max_range:
		queue_free()

func _on_hurtbox_landed_hit() -> void:
	set_physics_process(false)
	animation_player.play("explode")
	await get_tree().create_timer(0.45).timeout
	queue_free()
