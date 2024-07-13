class_name PlayerRun
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _idle_path : NodePath
@export var _jump_path : NodePath
@export var _fall_path : NodePath


# Private Members
# Default Callbacks
# Public Functions
	
func fixed_update(delta: float, time_in_state: float) -> void:	
	if _player.get_flat_velocity().is_zero_approx():
		change_state.emit(get_node(_idle_path))
		

func unhandled_input(event: InputEvent) -> void:
	_default_movement(event)
	_default_look(event)
	_default_shoot(event)
	
	if event.is_action("jump"):
		change_state.emit(get_node(_jump_path))
		
# Private Functions
# Signal Functions


