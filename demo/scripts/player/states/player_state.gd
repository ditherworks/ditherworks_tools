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
func _default_movement(event: InputEvent) -> void:
	var left_right := event.is_action("move_left") or event.is_action("move_right")
	var forward_back := event.is_action("move_forward") or event.is_action("move_backward")
	if left_right or forward_back:
		_player.set_move_input(Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_forward", "move_backward")))


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
