class_name Knight extends Enemy

@export var aggro_range : float = 320.0
@export var attack_range : float = 48.0

@export var attack_cooldown : float = 2.0
var attack_ready : float = true
var attack_timer : Timer

var target : Player

# DEBUGGING
@export var raycast : RayCast2D

func _ready() -> void:
	super()
	target = Player.player
	target.player_died.connect(queue_free)
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.timeout.connect(set_attack_ready)
	
func _physics_process(delta: float) -> void:
	if not target:
		return
		
	super(delta)
	
func _process(delta: float) -> void:
	if not target:
		return
		
	super(delta)
	raycast.target_position = (center.global_position.direction_to(Player.player.center.global_position) * 
		center.global_position.distance_to(Player.player.center.global_position))
	if action_locked:
		return
	if not player_in_aggro_range():
		if current_state != States.IDLE:
			change_state(state_nodes[Entity.States.IDLE])
		pass # CHANGE STATE TO IDLE
	else:
		if player_in_attack_range():
			if attack_ready:
				attack_ready = false
				state_nodes[States.ATTACKING].target_dir = raycast.target_position
				held_item.item.use(self, center.global_position.direction_to(Player.player.center.global_position))
				attack_timer.start()
				#change_state(state_nodes[Entity.States.ATTACKING])
			else:
				if current_state != States.CIRCLING_TARGET:
					change_state(state_nodes[Entity.States.CIRCLING_TARGET])
				pass # CHANGE STATE TO CIRCLING
		else:
			if current_state != States.CHASING_TARGET:
				change_state(state_nodes[Entity.States.CHASING_TARGET])
			pass # CHANGE STATE TO CHASING
			
func set_attack_ready() -> void:
	attack_ready = true
	
func player_in_aggro_range() -> bool:
	return center.global_position.distance_to(Player.player.center.global_position) <= aggro_range
func player_in_attack_range() -> bool:
	return center.global_position.distance_to(Player.player.center.global_position) <= attack_range
