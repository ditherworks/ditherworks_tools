class_name PlayerIdle
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _run_path : NodePath
@export var _jump_path : NodePath
@export var _fall_path : NodePath


# Private Members
# Default Callbacks
# Public Functions
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_move()
	
	if not _player.is_on_floor():
		change_state.emit(get_node(_fall_path))
		return
			
	if not _player.get_flat_velocity().is_zero_approx():
		change_state.emit(get_node(_run_path))
		return
		
	if Input.is_action_just_pressed("jump"):
		change_state.emit(get_node(_jump_path))
		return
	
	
# Private Functions
# Signal Functions


