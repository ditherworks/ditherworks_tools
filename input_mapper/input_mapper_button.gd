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


# Default Callbacks
func _ready() -> void:
	_prompt_label.visible = false
	
	
func _input(event: InputEvent) -> void:
	if not _listening:
		return
		
	var key := event as InputEventKey
	if key and key.pressed:
		if key.keycode == KEY_ESCAPE:
			reset()
		else:
			_remap(event)
		accept_event()
	
	var mouse := event as InputEventMouseButton	
	if mouse and mouse.pressed and not mouse.double_click:
		_remap(event)
		accept_event()

		
# Public Functions
func configure(action: String, label: String, event: InputEvent) -> void:
	_action = action
	_event = event
	_action_label.text = label
	_prompt_label.visible = false
	
	if event is InputEventJoypadButton:
		_key_label.visible = false
		_button_icon.visible = true
		#... _button_icon.texture = 
	else:
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
	
