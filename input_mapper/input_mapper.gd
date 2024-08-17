class_name InputMapper
extends PanelContainer


# Signals
# Enums
enum Type { Keyboard, Pad }


# Constants
# Members
@export var _button_scene : PackedScene
@export var _action_labels : Dictionary
@export var _buttons_parent : Control
@export var _reset_button : Button


# Default Callbacks
func _ready() -> void:
	_reset_button.pressed.connect(_rebuild_buttons)
	_rebuild_buttons()
		
	
# Public Functions
# Private Functions
func _rebuild_buttons() -> void:
	if not _buttons_parent:
		return
		
	# remove all existing buttons
	var buttons := _buttons_parent.get_children()
	for button : Button in buttons:
		button.queue_free()
		
	# create new buttons
	if _button_scene:
		for action in _action_labels:
			_add_button(action)
		
		
func _add_button(action: String) -> void:
	var button := _button_scene.instantiate() as InputMapperButton
	_buttons_parent.add_child(button)
	
	var key_event := _get_first_key_event(InputMap.action_get_events(action))
	button.configure(action, _action_labels[action], key_event)
	button.remap_begin.connect(_enable_buttons.bind(false))
	button.remap_complete.connect(_enable_buttons.bind(true))
		

func _get_first_key_event(events: Array) -> InputEventKey:
	for key : InputEvent in events:
		if key is InputEventKey:
			return key as InputEventKey
	return null
	

func _enable_buttons(enable : bool) -> void:
	for button : Button in _buttons_parent.get_children():
		button.disabled = not enable
		
