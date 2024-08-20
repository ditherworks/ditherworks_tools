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
	if _is_escape_request(event):
		if _key_mapper.is_active() or _pad_mapper.is_active():
			_enable_mapper(_key_mapper, false)
			_enable_mapper(_pad_mapper, false)
		else:
			_front_end.go_back()
			
		accept_event()
	
	
# Public Functions
# Private Functions
func _button_pressed(button: Button) -> void:
	if button == _key_button:
		_enable_mapper(_key_mapper, true)
	if button == _pad_button:
		_enable_mapper(_pad_mapper, true)
		
	
func _enable_mapper(mapper: InputMapper, enable: bool) -> void:
	mapper.activate(enable)
	_key_button.focus_mode = Control.FocusMode.FOCUS_NONE if enable else Control.FocusMode.FOCUS_ALL
	_key_button.disabled = enable
	_pad_button.focus_mode = Control.FocusMode.FOCUS_NONE if enable else Control.FocusMode.FOCUS_ALL
	_pad_button.disabled = enable
		

func _is_escape_request(event: InputEvent) -> bool:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		return true
	
	var button := event as InputEventJoypadButton
	if button and button.pressed and button.button_index == JOY_BUTTON_B:
		return true
		
	return false
