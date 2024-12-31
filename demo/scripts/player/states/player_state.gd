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
func _default_movement() -> void:	
	var dir := Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_forward", "move_backward"))
	_player.set_move_direction(_player.global_basis * dir)
	_player.set_speed(Player.SPEED)


func _default_shoot() -> void:
	if Input.is_action_just_pressed("shoot") and _player._bullet_cast:
		if _player._bullet_cast.shoot():
			DebugLines.draw_point(_player._bullet_cast.get_end_point(), 0.2, Color.ORANGE_RED, 0.5)
		DebugLines.draw_line(_player._bullet_cast.global_position, _player._bullet_cast.get_end_point(), Color.RED, 0.5)
		
	
# Signal Functions
