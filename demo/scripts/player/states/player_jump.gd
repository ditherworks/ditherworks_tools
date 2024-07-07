class_name PlayerJump
extends PlayerState


# Signals
# Enums
# Constants
# Export Members
@export var _fall_path : NodePath


# Private Members
# Default Callbacks
# Public Functions
func enter() -> void:
	_player.velocity.y = 4.0
	#_player.global_position += Vector3.UP * 0.1
	
	
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_move()
	
	if _player.velocity.y < 0.0:
		change_state.emit(get_node(_fall_path))
		return
	
	
# Private Functions
# Signal Functions


