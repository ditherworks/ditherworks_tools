class_name DemoPauseScreen
extends PauseScreen


# Signals
# Enums
# Constants
# Members
@export var _return_button : Button
@export var _exit_button : Button


# Default Callbacks
func _ready() -> void:
	_return_button.pressed.connect(_button_pressed.bind(_return_button))
	_exit_button.pressed.connect(_button_pressed.bind(_exit_button))
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		g_game.pause(false)
		get_viewport().set_input_as_handled()
	
	
# Public Functions
# Private Functions
func _button_pressed(button: Button) -> void:
	if button == _return_button:
		g_game.pause(false)
		return
		
	if button == _exit_button:
		g_game.switch_to_front_end()
		return
