class_name ControlsScreen
extends MenuScreen


# Signals
# Enums
# Constants
# Members
@export var _key_mapper : InputMapper
	
	
# Default Callbacks
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		_front_end.go_back()
		accept_event()
	
	
# Public Functions
func exit() -> void:
	super()
	
	_key_mapper.save()
	
	
# Private Functions
