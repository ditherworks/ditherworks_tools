class_name FrontEnd
extends Control


# Signals
# Enums
# Constants
# Members
@export var _starting_screen : MenuScreen

var _current_screen : MenuScreen


# Default Callbacks
func _ready() -> void:
	_register_with_children()
	
	# disable
	for child : MenuScreen in get_children():
		child.exit()
	
	goto_screen(_starting_screen)
	
	
# Public Functions
func goto_screen(screen: MenuScreen, remember_previous := true) -> void:
	if not screen or _current_screen == screen:
		return
	
	var previous := _current_screen
	if _current_screen:
		_current_screen.exit()
	_current_screen = screen
	_current_screen.enter(previous if remember_previous else null)
	
	
func go_back() -> void:
	if _current_screen._previous:
		goto_screen(_current_screen._previous, false)
		
		
# Private Functions
func _register_with_children() -> void:
	for child in get_children():
		if child is MenuScreen:
			(child as MenuScreen).register_front_end(self)
