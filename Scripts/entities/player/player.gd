class_name Player extends Entity

static var player : Player
signal player_died

@export var hotbar : Hotbar
@export var inventory : Inventory
#@export var held_item : HeldItem
@export var direction_indicator : Sprite2D
@export var camera : Camera2D

@export var ui : UI
var in_menu : bool = false

@export var scoreboard : Scoreboard
# STATE MACHINE

func _ready() -> void:
	PlayerCursor.set_cursor(PlayerCursor.CURSOR_MODES.DEFAULT)
	super()
	player = self

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	update_weapon_direction()
	held_item.target_pos = get_global_mouse_position()
	#if held_item and held_item.item:
		#
		#weapon.sprite.texture = held_item.item.texture
	#else:
		#weapon.sprite.texture = null
	
func _physics_process(delta: float) -> void:
	super(delta)
	
func _input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
	if event is InputEventKey or event is InputEventMouseButton and event.pressed:
		if event.is_action_pressed("TOGGLE_INVENTORY"):
			inventory.visible = !inventory.visible
	if in_menu:
		return
		
	if event is InputEventKey and event.pressed:
		if event.unicode >= KEY_1 and event.unicode <= KEY_5:
			hotbar.set_selected(event.unicode-48, self)

	if not action_locked:
		if event is InputEventKey or event is InputEventMouseButton and event.pressed:
			if event.is_action_pressed("ITEM_USE"):
				if held_item and held_item.item:
					state_nodes[States.ATTACKING].target_dir = get_global_mouse_position() # MAYBE HAVE A TARGET_DIR VARIABLE IN ENTITY CLASS
					held_item.item.use(self, weapon_dir)
			elif event.is_action_pressed("ROLL"):
				change_state(state_nodes[States.ROLL])
				
func die() -> void:
	set_physics_process(false)
	set_process(false)
	set_process_input(false)
	hurtbox.disable()
	hurtbox.queue_free()
	
	animation_player.play(animation_path + "death")
	await get_tree().create_timer(0.8).timeout
	process_mode = Node.PROCESS_MODE_DISABLED
	sprites.modulate.a = 0.0
	update_high_score()
	player_died.emit()
	var ui : GameOverUI = UiManager.UI_SCENES[UiManager.UIs.GAME_OVER].instantiate()
	UiManager.switch_ui(ui)

func update_high_score() -> void:
	var highscore_data_path : String = "res://Resources/SaveData/highscore_data.tres"
	var highscore_data : HighscoreData
	if not ResourceLoader.exists(highscore_data_path):
		highscore_data = HighscoreData.new()
	else:
		highscore_data = ResourceLoader.load(highscore_data_path)
	highscore_data.highscore = max(highscore_data.highscore, scoreboard.score)
	ResourceSaver.save(highscore_data, highscore_data_path)
	
func handle_movement(delta: float) -> void:
	direction.x = Input.get_action_strength("MOVE_RIGHT") - Input.get_action_strength("MOVE_LEFT")
	direction.y = Input.get_action_strength("MOVE_DOWN") - Input.get_action_strength("MOVE_UP")
	direction = direction.normalized()
	velocity = lerp(velocity, direction * speed, min(acceleration * delta, 1.0))
	
func handle_movement_direction() -> void:
	cardinal_direction = get_cardinal_direction(global_position.direction_to(get_global_mouse_position()))
	set_facing(cardinal_direction)
		
func update_weapon_direction() -> void:
	if action_locked:
		return
	weapon_dir = center.global_position.direction_to(get_global_mouse_position())
	direction_indicator.rotation = atan2(weapon_dir.y, weapon_dir.x)
