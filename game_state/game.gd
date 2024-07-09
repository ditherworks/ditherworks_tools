class_name Game
extends Node


@export var _starting_state : NodePath
@export var _transition_path : NodePath
@onready var _transition := get_node(_transition_path) as CrossFade


var _current_state : GameState
var _next_state : GameState

var _states : Array[GameState]


func _ready() -> void:
	# gather all states
	for child in get_children():
		if child is GameState:
			_states.push_back(child)
	
	if not _states.is_empty():
		# remove all states bar a single, starting state
		if not _starting_state:
			_current_state = _states[0]
		else:
			_current_state = get_node(_starting_state)
		
		for state in _states:
			if not state == _current_state:
				remove_child(state)
		
		_current_state.enter()
		
	else:
		print("Warning - No game states found")
	

# Public Functions
func get_state(state_name: String) -> GameState:
	if not _states.is_empty():
		# check states array
		for state : GameState in _states:
			if state.name == state_name:
				return state
	else:
		# check children (in case we're calling this before _ready)
		for child : GameState in get_children():
			if child.name == state_name:
				return child
			
	print("Failed to find state with name...", state_name)
	return null	
	

func request_state_transition(next: GameState, callable := Callable()) -> void:
	if next == null:
		printerr("next state parameter is null")
		return
	
	_next_state = next
	_current_state.enable(false)
	
	_transition.hide()
	
	await _transition.hide_complete
	
	_change_state(_next_state)
	
	if not callable.is_null():
		callable.call()
		
	_transition.reveal()
		
	
func _change_state(next: GameState) -> void:
	_current_state.exit()
	add_child(next)
	move_child(next, 0)
	next.enable(true)
	remove_child(_current_state)
	_current_state = next
	next.enter()
