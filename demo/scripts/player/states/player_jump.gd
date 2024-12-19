class_name PlayerJump
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _fall_state : PlayerFall


# Private Members
# Default Callbacks
# Public Functions
func enter() -> void:
	_player.jump(6.0)
	
	
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_movement()
	_default_shoot()
	
	if _player.velocity.y < 0.0:
		change_state.emit(_fall_state)
		return

	
# Private Functions
# Signal Functions
