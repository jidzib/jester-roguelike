class_name StateMachine extends Node

@export var starting_state : State
var current_state : State

func initialize(parent: Entity) -> void:
	var children : Array[Node] = get_children()
	current_state = starting_state
	for child in children:
		child.parent = parent
		#change_state(child)
	change_state(starting_state)

func change_state(new_state : State) -> void:
	if new_state != current_state:
		current_state.exit()
		current_state = new_state
		new_state.enter()
		
func process_frame(delta: float) -> void:
	current_state.process_frame(delta)

func process_physics(delta: float) -> void:
	current_state.process_physics(delta)

func process_input(event: InputEvent) -> void:
	current_state.process_input(event)
