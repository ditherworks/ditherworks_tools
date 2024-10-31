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
	_player._jump(0.4)
	
	
func fixed_update(delta: float, time_in_state: float) -> void:
	_default_movement()
	
	if _player.velocity.y < 0.0:
		change_state.emit(get_node(_fall_path))
		return


func unhandled_input(event: InputEvent) -> void:
	_default_look(event)
	_default_shoot(event)
		
	
# Private Functions
# Signal Functions
