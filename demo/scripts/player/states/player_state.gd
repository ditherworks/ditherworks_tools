class_name PlayerState
extends BaseState


# Signals
# Enums
# Constants
# Export Members
# Private Members
@onready var _player := owner as Player


# Default Callbacks
# Public Functions
# Private Functions
func _default_move() -> void:
	# grab input vector
	var input := Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		input += Vector3.FORWARD
	if Input.is_key_pressed(KEY_S):
		input += Vector3.BACK
	if Input.is_key_pressed(KEY_A):
		input += Vector3.LEFT
	if Input.is_key_pressed(KEY_D):
		input += Vector3.RIGHT
	
	_player.set_move_input(input)
	
	
# Signal Functions


