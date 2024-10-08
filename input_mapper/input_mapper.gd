class_name InputMapper
extends PanelContainer


# Signals
# Enums
enum InputType { Keyboard, Pad }


# Constants
const FILE_PATH := "user://input.tres"


# Members
@export var _button_scene : PackedScene
@export var _valid_actions : Array[PackedStringArray]	# [action_name, in-game text label]
@export var _buttons_parent : Control
@export var _reset_button : Button
@export var _type : InputType
@export var _pad_icons : InputIcons

var _dirty := false


# Default Callbacks
func _ready() -> void:
	_reset_button.pressed.connect(_reset)
	
	_load()
	
	_rebuild_buttons()
	
	
# Public Functions
func activate(enable := true) -> void:
	visible = enable
	set_process_input(enable)
	
	if enable:
		(_buttons_parent.get_child(0) as Button).grab_focus()
	else:
		_save()
		
		
func is_active() -> bool:
	return visible
	
	
# Private Functions
func _save() -> void:
	if _dirty:
		InputData.new().save(_get_valid_action_names(), FILE_PATH)	
		_dirty = false
	
	
func _load() -> void:
	if not ResourceLoader.exists(FILE_PATH, "InputData"):
		print("no InputData to load")
		return

	var data := ResourceLoader.load(FILE_PATH, "InputData")
	if is_instance_valid(data):
		data.apply()
	else:
		print("failed to load InputData")
	
	
func _rebuild_buttons() -> void:
	if not _buttons_parent:
		return
		
	# remove all existing buttons
	var buttons := _buttons_parent.get_children()
	for button : Button in buttons:
		button.queue_free()
		
	# create new buttons
	if _button_scene:
		for action : PackedStringArray in _valid_actions:
			_add_button(action[0], action[1])
		
		
func _add_button(action: String, label: String) -> void:
	var event := _get_first_event(InputMap.action_get_events(action))
	if event:
		var button := _button_scene.instantiate() as InputMapperButton
		button.register_icons(_pad_icons)
		_buttons_parent.add_child(button)
		button.configure(action, label, event)
		button.remap_begin.connect(_enable_buttons.bind(false))
		button.remap_complete.connect(_enable_buttons.bind(true))
		

func _get_first_event(events: Array) -> InputEvent:
	if _type == InputType.Keyboard:
		for event : InputEvent in events:
			if event is InputEventKey or event is InputEventMouseButton:
				return event
	elif _type == InputType.Pad:
		for event : InputEvent in events:
			if event is InputEventJoypadButton:
				return event
			if event is InputEventJoypadMotion:
				return event
	return null
	
	
func _get_valid_action_names() -> Array[String]:
	var list : Array[String]
	for entry : PackedStringArray in _valid_actions:
		list.push_back(entry[0])
	return list
		

func _enable_buttons(enable : bool) -> void:
	for button : Button in _buttons_parent.get_children():
		button.disabled = not enable
		
	_reset_button.disabled = not enable
	
	if not enable:
		_dirty = true
	
	
func _reset() -> void:
	InputMap.load_from_project_settings()
	_dirty = true
	_rebuild_buttons()
