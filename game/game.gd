class_name Game
extends Node


# Signals
# Enums
# Constants
# Members
@export var _hud : Hud
@export var _pause : PauseScreen
@export var _front_end : FrontEnd
@export var _transition : Transition

@export_group("Config")
@export var _start_in_game := false

var _world : Node3D


# Default Callbacks
func _ready() -> void:
	_prep_defaults()
		
	if _start_in_game:
		switch_to_world(false)
	else:
		switch_to_front_end(false)
	
	
# Public Functions
func pause(enable: bool) -> void:
	get_tree().paused = enable
	_hud.visible = not enable
	_pause.visible = enable
		
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if enable else Input.MOUSE_MODE_CAPTURED
	
	
func switch_to_front_end(use_transition := true) -> void:
	get_tree().paused = false
	_world.process_mode = Node.PROCESS_MODE_DISABLED
	
	if use_transition and _transition:
		_transition.transition_out()
		await _transition.out_complete
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	_hud.visible = false
	_pause.visible = false
	_front_end.visible = true
	_front_end.process_mode = Node.PROCESS_MODE_INHERIT
	_world.visible = false
	
	if use_transition and _transition:
		_transition.transition_in()
		

func switch_to_world(use_transition := true) -> void:
	_front_end.process_mode = Node.PROCESS_MODE_DISABLED
	
	if use_transition and _transition:
		_transition.transition_out()
		await _transition.out_complete

	_hud.visible = true
	_pause.visible = false
	_front_end.visible = false
	_world.visible = true
	_world.process_mode = Node.PROCESS_MODE_PAUSABLE
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	get_tree().paused = false
	if use_transition and _transition:
		_transition.transition_in()
		
				
# Private Functions
func _prep_defaults() -> void:
	if not _hud:
		_hud = Control.new()
		add_child(_hud)
		
	if not _pause:
		_pause = Control.new()
		add_child(_pause)
	
	if not _front_end:
		_front_end = Control.new()
		add_child(_front_end)
		
	var root := get_tree().root
	_world = root.get_child(root.get_child_count() - 1) as Node3D
	if not _world:
		_world = Node3D.new()
		add_child(_world)
		
	process_mode = Node.PROCESS_MODE_ALWAYS
	_world.process_mode = Node.PROCESS_MODE_PAUSABLE
	_hud.process_mode = Node.PROCESS_MODE_PAUSABLE
	_pause.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_front_end.process_mode = Node.PROCESS_MODE_ALWAYS
	_transition.process_mode = Node.PROCESS_MODE_ALWAYS
	
