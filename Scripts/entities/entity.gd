class_name Entity extends CharacterBody2D

# SIGNALS 

signal died

@export var stats : Stats

# STATS
@export var speed : float
var acceleration : float = 50.0

# NODES
@export var sprites : SpriteGroup
@export var animation_player : AnimationPlayer
@export var animation_path : String = ""
@export var hurtbox : Hurtbox
@export var center : Marker2D

var facing : String = "front"
var direction : Vector2 = Vector2.ZERO
var weapon_dir : Vector2
var action_locked : bool = false
var movement_locked : bool = false

enum CardinalDirections {
	NORTH, EAST, SOUTH, WEST
}
var cardinal_direction : CardinalDirections

@export var state_machine : StateMachine

enum States {
	IDLE,
	ATTACKING,
	BLOCKING,
	DRINKING_POTION,
	SPELLCASTING,
	HURT,
	CIRCLING_TARGET,
	CHASING_TARGET,
	ROLL
}

@export var state_nodes : Dictionary[States, State]
var current_state : States = States.IDLE

@export var sound : AudioStreamPlayer2D

@export var held_item : HeldItem

func _ready() -> void:
	state_machine.initialize(self)
	died.connect(die)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	# HANDLE MOVEMENT
	if not movement_locked:
		handle_movement(delta)
		
	# HANDLE USE DIRECTION
	if not action_locked:
		handle_movement_direction()
		handle_movement_animation()
	move_and_slide()

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func check_alive(hp: int) -> void:
	if hp <= 0:
		died.emit()
	
func die() -> void:
	queue_free()

func get_cardinal_direction(_direction : Vector2 = Vector2.ZERO) -> CardinalDirections:
	if abs(_direction.x) > abs(_direction.y):
		if _direction.x > 0:
			return CardinalDirections.EAST
		elif _direction.x < 0:
			return CardinalDirections.WEST
	else:
		if _direction.y > 0:
			return CardinalDirections.SOUTH
		elif _direction.y < 0:
			return CardinalDirections.NORTH
	return cardinal_direction

func set_facing(_direction: CardinalDirections) -> void:
	if _direction == CardinalDirections.EAST:
		sprites.scale.x = 1.0
		facing = "side"
	elif _direction == CardinalDirections.WEST:
		sprites.scale.x = -1.0
		facing = "side"
	elif _direction == CardinalDirections.SOUTH:
		facing = "front"
	elif _direction == CardinalDirections.NORTH:
		facing = "back"
		
func change_state(new_state : State) -> void:
	state_machine.change_state(new_state)
	
func perform_attack(attack_duration: float, attack_name: String, speed_multiplier: float = 1.0) -> void:
	state_nodes[States.ATTACKING].initialize(attack_duration, attack_name, speed_multiplier)
	change_state(state_nodes[States.ATTACKING])
	
func is_parried(source: Entity, attack_type: String, damage: int) -> bool:
	if current_state == States.BLOCKING:
		var opposites : Dictionary[CardinalDirections, CardinalDirections] = {
			CardinalDirections.NORTH : CardinalDirections.SOUTH,
			CardinalDirections.SOUTH : CardinalDirections.NORTH,
			CardinalDirections.EAST : CardinalDirections.WEST,
			CardinalDirections.WEST : CardinalDirections.EAST,
		}
		if cardinal_direction == opposites[source.cardinal_direction]:
			sound.play()
			return true
	return false

func hit_flash() -> void:
	sprites.change_shader(Enums.Shaders.HIT_FLASH)
	await get_tree().create_timer(0.25).timeout
	sprites.remove_shader()

func handle_movement(delta: float) -> void:
	pass
func handle_movement_direction() -> void:
	cardinal_direction = get_cardinal_direction(direction)
	set_facing(cardinal_direction)

func handle_movement_animation() -> void:
	if direction != Vector2.ZERO:
		animation_player.play(animation_path+facing+"_walk")
	else:
		animation_player.play(animation_path+facing+"_idle")
	
func _on_tree_entered() -> void:
	stats.update_hp.connect(check_alive)
	
func _on_tree_exited() -> void:
	stats.update_hp.disconnect(check_alive)
