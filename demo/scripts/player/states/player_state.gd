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
	_player._set_move_direction(_player.global_basis * dir, _player.SPEED)


func _default_look(event: InputEvent) -> void:
	var mouse := event as InputEventMouseMotion
	if mouse:
		_player.update_look_input(mouse.screen_relative * MOUSELOOK_SCALING)


func _default_shoot(event: InputEvent) -> void:
	if Utils.action_just_pressed(event, "shoot"):
		if _player._bullet_cast:
			_player._bullet_cast.shoot()
			g_console.print_line("pew", Color.LIME_GREEN)
		
	
# Signal Functions
