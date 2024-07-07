class_name GameplayState
extends GameState


# Default Callbacks
func _input(event: InputEvent) -> void:
	# quit request
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		_game.request_state_transition(_game.get_state("MenuState"))


# Public Functions
func enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	
	

