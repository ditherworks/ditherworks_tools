class_name ControlsScreen
extends MenuScreen


# Signals
# Enums
# Constants
# Members
# Default Callbacks
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		_front_end.go_back()
		accept_event()
	
	
# Public Functions
# Private Functions
