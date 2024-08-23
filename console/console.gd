class_name Console
extends Control


# Classes
class Command:
	var handle : String
	var callable : Callable
	
	func _init(hnd: String, callback: Callable) -> void:
		handle = hnd
		callable = callback
		
	
# Signals
# Enums
# Constants
const SPEED := 300.0


# Members
@export var _output : Label
@export var _input_line : LineEdit


var _active := true


# Default Callbacks
func _ready() -> void:
	pass
	
	
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key:
		if key.pressed and key.keycode == KEY_SLASH:
			_activate(not _active)
			accept_event()
		if key.pressed and key.keycode == KEY_ESCAPE and _active:
			_activate(false)
			accept_event()
			
		
func _process(delta: float) -> void:
	var target := Vector2(0.0, get_viewport_rect().size.y - size.y) if _active else Vector2(0.0, get_viewport_rect().size.y)
	global_position = global_position.move_toward(target, SPEED * delta)


# Public Functions

# Private Functions
func _activate(active := true) -> void:
	_active = active
	
	if active:
		_input_line.grab_focus()
	else:
		get_viewport().gui_release_focus()
	

#@onready var _line := %LineEdit as LineEdit
#@onready var _container := (%Container as PanelContainer)
#
#var _active := false
#var _commands : Array[Command]
#var _history : Array[String]
#var _history_index := 0
#
#
## Default Callbacks
#func _ready() -> void:
	#_line.text_submitted.connect(_command_submitted)
	#_line.text_changed.connect(_line_changed)
	#
	## disable ourself in non-editor builds
	#if not OS.has_feature("editor"):
		#process_mode = Node.PROCESS_MODE_DISABLED
		#set_process(false)
		#set_process_input(false)
		#set_physics_process(false)
	#
	#
#func _process(delta: float) -> void:
	#var target := Vector2(0.0, size.y - _container.size.y)
	#if not _active:
		#target = Vector2(0.0, size.y)
	#
	#if not global_position.is_equal_approx(target):
		#_container.position = _container.position.move_toward(target, SPEED * delta)
		#
		#if _container.position.is_equal_approx(target):
			#if not _active:
				#visible = false
		#
		#
#func _input(event: InputEvent) -> void:
	#var key := event as InputEventKey
	#if not key or not key.pressed:
		#return
	#
	#if key.keycode == KEY_SLASH:
		#_enable(not _active)
	#
	#if _active:		
		#if key.keycode == KEY_UP:
			#_scroll_history(-1)
			#get_viewport().set_input_as_handled()
		#if key.keycode == KEY_DOWN:
			#_scroll_history(1)
			#get_viewport().set_input_as_handled()
				#
	#
## Public Functions
#func register_command(handle: String, callable: Callable) -> void:
	#for com : Command in _commands:
		#if com.handle == handle:
			#return
	#
	#_commands.push_back(Command.new(handle, callable))
	#
	#
#func send_command(com: String) -> void:
	#_command_submitted(com)
		#
	#
## Private Functions
#func _enable(activate: bool) -> void:
	#if activate:
		#visible = true
		#_line.grab_focus()
	#else:
		#_line.release_focus()
	#
	#_active = activate
	#
	#
#func _command_submitted(text: String) -> void:
	#if not OS.has_feature("editor"):
		#return
		#
	#var handle := text.substr(0, text.find(" "))
	#for com : Command in _commands:
		#if com.handle == handle:
			#_execute_command(com, text)
			#_output(text)
			#_append_history(text)
			#_line.clear()
			#return
	#
	#_output("unrecognised command: " + text)
	#_append_history(text)
	#_line.clear()
	#
	#
#func _execute_command(command: Command, text: String) -> void:
	#var params := text.split(" ")
	#params.remove_at(0)
	#command.callable.call(params)
			#
	#
#func _line_changed(text: String) -> void:
	#_line.text = _line.text.replace("/", "")
	#_line.caret_column = _line.text.length()
	#
	#
#func _output(text: String) -> void:
	#(%History as Label).text = text
	#
	#
#func _append_history(text: String) -> void:
	#_history.push_back(text)
	#_history_index = -1
	#
#
#func _scroll_history(step: int) -> void:
	#if _history.is_empty():
		#return
		#
	#if _history_index == -1:
		#if step < 0:
			#_history_index = _history.size()-1
		#else:
			#_history_index = 0
	#else:
		#_history_index = wrapi(_history_index + step, 0, _history.size())
		#
	#_line.text = _history[_history_index]
	#_line_changed(_line.text)
	#
	
# Signal Functions
