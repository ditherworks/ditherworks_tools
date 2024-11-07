class_name PlayerRun
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _idle_state : PlayerIdle
@export var _jump_state : PlayerJump
@export var _fall_state : PlayerFall


# Private Members
# Default Callbacks
# Public Functions
	
func fixed_update(delta: float, time_in_state: float) -> void:	
	_default_movement()
	_default_shoot()
		
	if _player.get_flat_velocity().is_zero_approx():
		change_state.emit(_idle_state)
		return
		
	if Input.is_action_just_pressed("jump"):
		change_state.emit(_jump_state)
		return
		
		
# Private Functions
# Signal Functions
