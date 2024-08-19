class_name ControlsScreen
extends MenuScreen


# Signals
# Enums
# Constants
# Members
@export var _key_button : Button
@export var _pad_button : Button

@export var _key_mapper : InputMapper
@export var _pad_mapper : InputMapper
	
	
# Default Callbacks
func _ready() -> void:
	_key_button.pressed.connect(_button_pressed.bind(_key_button))
	_pad_button.pressed.connect(_button_pressed.bind(_pad_button))
	
	
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		if _key_mapper.is_active() or _pad_mapper.is_active():
			_key_mapper.activate(false)
			_pad_mapper.activate(false)
		else:
			_front_end.go_back()
		accept_event()
	
	
# Public Functions
# Private Functions
func _button_pressed(button: Button) -> void:
	if button == _key_button:
		_key_mapper.activate()
	if button == _pad_button:
		_pad_mapper.activate()
