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
	if _listening:
		var key := event as InputEventKey
		if key and key.pressed:
			InputMap.action_erase_event(_action, _event)
			InputMap.action_add_event(_action, event)
			configure_for_key(_action, _action_label.text, event)
			_listening = false
			remap_complete.emit()
			accept_event()

		
# Public Functions
func configure_for_key(action: String, label: String, event: InputEvent) -> void:
	_action = action
	_event = event
	
	_action_label.text = label
	_key_label.text = event.as_text().trim_suffix("(Physical)")
	_key_label.visible = true
	_button_icon.visible = false
	_prompt_label.visible = false
	
	
func reset() -> void:
	_listening = false
	
		
# Private Functions
func _pressed() -> void:
	prints(_action, "awaiting remap")
	
	_key_label.visible = false
	_button_icon.visible = false
	_prompt_label.visible = true
	
	_listening = true
	
	remap_begin.emit()
