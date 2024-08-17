class_name MenuScreen
extends Control


# Signals
# Enums
# Constants
# Members
var _front_end : FrontEnd
var _previous : MenuScreen


# Default Callbacks	
# Public Functions
func enter(previous: MenuScreen) -> void:
	visible = true
	if previous:
		_previous = previous
	
	
func exit() -> void:
	visible = false
	
	
func register_front_end(front_end: FrontEnd) -> void:
	_front_end = front_end
	
	
# Private Functions
