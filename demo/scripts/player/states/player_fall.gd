class_name PlayerFall
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _idle_state : PlayerIdle
@export var _run_state : PlayerRun


# Private Members
# Default Callbacks
# Public Functions
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_movement()
	_default_shoot()
	
	if _player.is_on_floor():
		if _player.get_flat_velocity().is_zero_approx():
			change_state.emit(_idle_state)
			return
		else:
			change_state.emit(_run_state)
			return
		
			
# Private Functions
# Signal Functions
