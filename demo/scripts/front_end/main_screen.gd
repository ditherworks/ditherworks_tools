class_name MainScreen
extends MenuScreen


# Signals
# Enums
# Constants
# Members
@export var _controls_screen : MenuScreen
@export var _continue_button : Button
@export var _controls_button : Button
@export var _exit_button : Button


# Default Callbacks
func _ready() -> void:
	_continue_button.pressed.connect(_button_pressed.bind(_continue_button))
	_controls_button.pressed.connect(_button_pressed.bind(_controls_button))
	_exit_button.pressed.connect(_button_pressed.bind(_exit_button))
	
	
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		g_game.switch_to_world()
		accept_event()
		
	
# Public Functions
# Private Functions
func _button_pressed(button: Button) -> void:
	if button == _continue_button:
		g_game.switch_to_world()
	if button == _controls_button:
		_front_end.goto_screen(_controls_screen)
	if button == _exit_button:
		get_tree().quit()
