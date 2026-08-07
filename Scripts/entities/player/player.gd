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
	PlayerCursor.set_cursor(PlayerCursor.CURSOR_MODES.DEFAULT)
	super()
	player = self

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	update_weapon_direction()
	
func _physics_process(delta: float) -> void:
	super(delta)
	
func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if event is InputEventKey and event.pressed:
		if event.unicode >= KEY_1 and event.unicode <= KEY_5:
			hotbar.set_selected(event.unicode-48, self)
		elif event.is_action_pressed("toggle_camera"):
			camera.enabled = !camera.enabled

	if not action_locked:
		if event is InputEventKey or event is InputEventMouseButton and event.pressed:
			if event.is_action_pressed("ITEM_USE"):
				if held_item and held_item.item:
					state_nodes[States.ATTACKING].target_dir = get_global_mouse_position() # MAYBE HAVE A TARGET_DIR VARIABLE IN ENTITY CLASS
					held_item.item.use(self, weapon_dir)
			elif event.is_action_pressed("ROLL"):
				change_state(state_nodes[States.ROLL])
				
func die() -> void:
	print("is this working")
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	hurtbox.disable() # <- not working
	hurtbox.queue_free()
	
	animation_player.play(animation_path + "death")
	await get_tree().create_timer(0.8).timeout
	#get_tree().root.add_child(camera.duplicate())
	queue_free()
	var ui : GameOverUI = UiManager.UI_SCENES[UiManager.UIs.GAME_OVER].instantiate()
	UiManager.switch_ui(ui)
	
func handle_movement(delta: float) -> void:
	direction.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	direction.y = Input.get_action_strength("MOVE_DOWN") - Input.get_action_strength("MOVE_UP")
	direction = direction.normalized()
	velocity = lerp(velocity, direction * speed, acceleration * delta)
		
func update_weapon_direction() -> void:
	if action_locked:
		return
	weapon_dir = center.global_position.direction_to(get_global_mouse_position())
	direction_indicator.rotation = atan2(weapon_dir.y, weapon_dir.x)
