class_name InputMapperButton
extends Button


# Signals
signal remap_begin()
signal remap_complete()


# Enums
# Constants
# Members
@export var _action_label : Label
@export var _key_label : Label
@export var _button_icon : TextureRect
@export var _prompt_label : Label

var _listening := false
var _action : String
var _event : InputEvent
var _icons : InputIcons

var _type : InputMapper.InputType


# Default Callbacks
func _ready() -> void:
	_prompt_label.visible = false
	
	
func _input(event: InputEvent) -> void:
	if not _listening:
		return
		
	# check for escape requests
	if _is_escape_request(event):
		reset()
	elif _is_valid_mapping(event):
		_remap(event)
				
	accept_event()
	
		
# Public Functions
func register_icons(icons: InputIcons) -> void:
	_icons = icons
	
	
func configure(action: String, label: String, event: InputEvent) -> void:
	if not event:
		return
		
	_action = action
	_event = event
	_action_label.text = label
	_prompt_label.visible = false
				
	if event is InputEventJoypadButton:
		_type = InputMapper.InputType.Pad
		_key_label.visible = false
		_button_icon.visible = true
		if _icons:
			_button_icon.texture = _icons.get_icon((event as InputEventJoypadButton).button_index)
	else:
		_type = InputMapper.InputType.Keyboard
		_key_label.visible = true
		_key_label.text = event.as_text().trim_suffix("(Physical)")
		_button_icon.visible = false
			
	
func reset() -> void:
	configure(_action, _action_label.text, _event)
	remap_complete.emit()
	_listening = false
	
		
# Private Functions
func _remap(event: InputEvent) -> void:
	InputMap.action_erase_event(_action, _event)
	InputMap.action_add_event(_action, event)
	
	configure(_action, _action_label.text, event)
		
	_listening = false
	remap_complete.emit()
	
	
func _pressed() -> void:
	_key_label.visible = false
	_button_icon.visible = false
	_prompt_label.visible = true
	
	_listening = true
	remap_begin.emit()
	

func _is_escape_request(event: InputEvent) -> bool:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_ESCAPE:
		return true
	
	var button := event as InputEventJoypadButton
	if button and button.pressed:
		if button.button_index == JOY_BUTTON_BACK or button.button_index == JOY_BUTTON_START:
			return true
	
	return false
	

func _is_valid_mapping(event: InputEvent) -> bool:
	match _type:
		InputMapper.InputType.Keyboard:
			var key := event as InputEventKey
			if key:
				if not key.pressed:
					return false
				return true
				
			var mouse := event as InputEventMouseButton
			if mouse:
				if not mouse.pressed:
					return false
				return true
				
		InputMapper.InputType.Pad:
			var button := event as InputEventJoypadButton
			if button:
				if not button.pressed:
					return false
				if button.button_index == JOY_BUTTON_BACK or button.button_index == JOY_BUTTON_START:
					return false
				return true
	
	return false
