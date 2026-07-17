class_name Player extends Entity

static var player : Player

@export var hotbar : Hotbar
#@export var held_item : HeldItem
@export var direction_indicator : Sprite2D
@export var camera : Camera2D

@export var ui : UI
# STATE MACHINE

var held_item : ItemSlot = null

func _ready() -> void:
	super()
	player = self

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	update_weapon_direction()
	
func _physics_process(delta: float) -> void:
	super(delta)
	#state_machine.process_physics(delta)
	## HANDLE MOVEMENT
	#if not movement_locked:
		#handle_movement(delta)
	## HANDLE USE DIRECTION
	#if not action_locked:
		#handle_movement_direction()
		#handle_movement_animation()
	#move_and_slide()
	
func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if event is InputEventKey and event.pressed:
		if event.unicode >= KEY_1 and event.unicode <= KEY_5:
			hotbar.set_selected(event.unicode-48, self)
		elif event.is_action_pressed("toggle_camera"):
			camera.enabled = !camera.enabled
			
	if not action_locked:
		if event is InputEventMouseButton and event.pressed:
			if event.is_action_pressed("item_use"):
				if held_item and held_item.item:
					state_nodes[States.ATTACKING].target = get_global_mouse_position() # MAYBE HAVE A TARGET_DIR VARIABLE IN ENTITY CLASS
					held_item.item.use(self, weapon_dir)
					
func handle_movement(delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	velocity = lerp(velocity, direction * speed, acceleration * delta)
		
func update_weapon_direction() -> void:
	if action_locked:
		return
	weapon_dir = center.global_position.direction_to(get_global_mouse_position())
	direction_indicator.rotation = atan2(weapon_dir.y, weapon_dir.x)
