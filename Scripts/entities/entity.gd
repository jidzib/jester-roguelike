class_name Entity extends CharacterBody2D

# SIGNALS 
signal lose_hp(amount : int)
signal gain_hp(amount : int)
signal lose_mana(amount : int)
signal gain_mana(amount : int)

@export var stats : Stats

# STATS
@export var max_hp : int
var current_hp : int
@export var attack : float
@export var defense : float
@export var magic : float
@export var speed : float
@export var max_mana : int
var current_mana : int
var acceleration : float = 50.0

var knockback_direction : Vector2 = Vector2.ZERO
var knocking_back : bool = false
var knockback_duration : float = 0.4
var knockback_progress : float = 0.0

# NODES
@export var sprites : SpriteGroup
@export var animation_player : AnimationPlayer
@export var animation_path : String = ""
@export var hurtbox : Hurtbox

var facing : String = "front"
var direction : Vector2 = Vector2.ZERO
var action_locked : bool = false
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
	IN_COMBAT
}

@export var state_nodes : Dictionary[States, State]
var current_state : States = States.IDLE

@export var sound : AudioStreamPlayer2D

func _ready() -> void:
	current_hp = max_hp
	current_mana = max_mana

func get_hit(damage: int, hit_location : Vector2) -> void:
	lose_hp.emit(damage)
	knockback_direction = -(global_position.direction_to(hit_location))
	knocking_back = true
	sprites.change_shader(Enums.Shaders.HIT_FLASH)
	
	if current_hp <= 0:
		die()
	
func _physics_process(delta: float) -> void:
	if knocking_back:
		velocity = lerp(velocity, knockback_direction * speed, acceleration * delta)
		move_and_slide()
		knockback_progress += delta
		if knockback_progress > knockback_duration:
			knockback_progress = 0.0
			knockback_direction = Vector2.ZERO
			knocking_back = false
			sprites.remove_shader()
			velocity = Vector2.ZERO

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


#func _on_tree_entered() -> void:
	#gain_hp.connect(increment_hp)
	#lose_hp.connect(decrement_hp)
	#gain_mana.connect(increment_mana)
	#lose_mana.connect(decrement_mana)
	#
#func _on_tree_exited() -> void:
	#gain_hp.disconnect(increment_hp)
	#lose_hp.disconnect(decrement_hp)
	#gain_mana.disconnect(increment_mana)
	#lose_mana.disconnect(decrement_mana)
