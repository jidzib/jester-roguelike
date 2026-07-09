class_name Knight extends Entity

@export var center : Marker2D

var animation_locked : bool = false

var target : Player
@export var held_item : HeldItem

# DEBUGGING
@export var raycast : RayCast2D
@export var label : Label

func _ready() -> void:
	super()
	state_machine.initialize(self)
	animation_player.play("front_idle")

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
func _physics_process(delta: float) -> void:
	super(delta)
	#if velocity.y > 0:
		#facing = "back"
	#elif velocity.y < 0:
		#facing = "front"
	#if velocity.x > 0:
		#sprite_container.scale.x = 1.0
	#elif velocity.y < 0:
		#sprite_container.scale.x = -1.0
	#if velocity.is_zero_approx():
		#velocity = Vector2.ZERO
	#state_machine.process_physics(delta)
	#if action_locked:
		#return
	#cardinal_direction = get_cardinal_direction(velocity)
	#set_facing(cardinal_direction)
	#update_direction("movement")
	#play_animation()
func handle_movement(delta: float) -> void:
	pass
	
func handle_movement_animation() -> void:
	if velocity == Vector2.ZERO:
		animation_player.play(animation_path+facing+"_idle")
	else:
		animation_player.play(animation_path+facing+"_walk")

func update_weapon_direction(target: Vector2) -> void:
	var weapon_dir : Vector2 = center.global_position.direction_to(target)
	#hurtbox.position = target * 20.0 + center.position
	
func _on_combat_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		state_machine.change_state(state_machine.get_node("InCombat"))

func _on_combat_detection_area_body_exited(body: Node2D) -> void:
	if action_locked:
		return
	if body is Player:
		target = null
		state_machine.change_state(state_machine.get_node("Idle"))
