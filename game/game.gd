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
	var root := get_tree().root
	_world = root.get_child(root.get_child_count() - 1) as Node3D
	
	_pause.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	if _start_in_game:
		switch_to_world()
	else:
		switch_to_front_end()
		
			
# Public Functions
func pause(enable: bool) -> void:
	get_tree().paused = enable
	if _hud:
		_hud.visible = not enable
	if _pause:
		_pause.visible = enable
		
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if enable else Input.MOUSE_MODE_CAPTURED
	
	
func switch_to_front_end() -> void:
	get_tree().paused = false
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if _hud:
		_hud.visible = false
	if _pause:
		_pause.visible = false
	
	if _front_end:
		_front_end.visible = true
		_front_end.process_mode = Node.PROCESS_MODE_INHERIT
	if _world:
		_world.visible = false
		_world.process_mode = Node.PROCESS_MODE_DISABLED
		

func switch_to_world() -> void:
	get_tree().paused = false
	
	if _hud:
		_hud.visible = true
	if _pause:
		_pause.visible = false
	
	if _front_end:
		_front_end.visible = false
		_front_end.process_mode = Node.PROCESS_MODE_DISABLED
	if _world:
		_world.visible = true
		_world.process_mode = Node.PROCESS_MODE_PAUSABLE
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
				
# Private Functions

	
