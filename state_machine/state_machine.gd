class_name StateMachine
extends Node


# Signals
# Export Members
@export var _starting_state : BaseState


# Private Members
var _active_state : BaseState
var _time_in_state := 0.0


# Default Callbacks
func _ready() -> void:
	var states := _get_all_states(self)
	
	# link to state change request signals
	for state : BaseState in states:
		state.change_state.connect(set_state)
	
	# select a starting state
	if _starting_state == null and not states.is_empty():
		set_state(states[0])
	else:
		set_state(_starting_state)
	
	
func _physics_process(delta: float) -> void:
	_time_in_state += delta
	if _active_state:
		_active_state.fixed_update(delta, _time_in_state)


# Public Functions	
func set_state(next: BaseState) -> void:
	if next == null:
		push_error("next state is null")
		return
				
	if _active_state:
		_active_state.exit()
	_active_state = next
	_active_state.enter()
	_time_in_state = 0.0


func get_state(node_name: String) -> BaseState:
	for child in get_children():
		if child.name == node_name:
			return child as BaseState
	printerr(node_name, "state not found")
	return null
		
		
# Private Functions
func _get_all_states(node: Node, states := []) -> Array:
	# recursive search to gather all states underneath a specific node
	if node is BaseState:
		states.push_back(node)
		
	for child in node.get_children():
		states = _get_all_states(child, states)
		
	return states
