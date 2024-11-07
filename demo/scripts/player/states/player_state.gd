class_name PlayerState
extends BaseState


# Signals
# Enums
# Constants
const MOUSELOOK_SCALING := 0.01


# Export Members
# Private Members
@onready var _player := owner as Player


# Default Callbacks
# Public Functions
# Private Functions
func _default_movement() -> void:	
	var dir := Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_forward", "move_backward"))
	_player.set_move_direction(_player.global_basis * dir, _player.SPEED)


func _default_shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		if _player._bullet_cast:
			_player._bullet_cast.shoot()
		
	
# Signal Functions
