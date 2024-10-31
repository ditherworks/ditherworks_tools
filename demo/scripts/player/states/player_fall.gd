class_name PlayerFall
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _idle_path : NodePath
@export var _run_path : NodePath


# Private Members
# Default Callbacks
# Public Functions
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_movement()
	
	if _player.is_on_floor():
		if _player.get_flat_velocity().is_zero_approx():
			change_state.emit(get_node(_idle_path))
		else:
			change_state.emit(get_node(_run_path))
		return
		
			
func unhandled_input(event: InputEvent) -> void:
	_default_look(event)
	_default_shoot(event)
	
			
# Private Functions
# Signal Functions
