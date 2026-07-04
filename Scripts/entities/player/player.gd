class_name Player extends Entity

@export var hotbar : Hotbar
@export var held_item : HeldItem
@export var center : Marker2D
@export var direction_indicator : Sprite2D
@export var camera : Camera2D

@export var ui : UI
# STATE MACHINE

func _ready() -> void:
	super()
	state_machine.initialize(self)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	update_weapon_direction()
	
func _physics_process(delta: float) -> void:
	super(delta)
	state_machine.process_physics(delta)
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	move_and_slide()

	if action_locked:
		return
	cardinal_direction = get_cardinal_direction(direction)
	set_facing(cardinal_direction)
	#update_direction("movement")
	
	if direction != Vector2.ZERO:
		animation_player.play(animation_path+facing+"_walk")
	else:
		animation_player.play(animation_path+facing+"_idle")
	
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
				if held_item.item:
					state_nodes[States.ATTACKING].target = get_global_mouse_position()
					held_item.item.use(self, weapon_dir)
					
			
func update_weapon_direction() -> void:
	if action_locked:
		return
	weapon_dir = center.global_position.direction_to(get_global_mouse_position())
	direction_indicator.rotation = atan2(weapon_dir.y, weapon_dir.x)
	#hurtbox.position = weapon_dir * 20.0 + center.position
