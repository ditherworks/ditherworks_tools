class_name PlayerIdle
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _run_state : PlayerRun
@export var _jump_state : PlayerJump
@export var _fall_state : PlayerFall


# Private Members
# Default Callbacks
# Public Functions
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_movement()
	_default_shoot()
	
	if Input.is_action_just_pressed("jump"):
		change_state.emit(_jump_state)
		return
	
	if not _player.is_on_floor():
		change_state.emit(_fall_state)
		return
			
	if not _player.get_flat_velocity().is_zero_approx():
		change_state.emit(_run_state)
		return
		
	
# Private Functions
# Signal Functions
