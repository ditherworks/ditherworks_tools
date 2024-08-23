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
@export var _output_line : Label
@export var _input_line : LineEdit


var _active := false
var _commands : Array[Command]
var _history : Array[String]
var _history_index := -1


# Default Callbacks
func _ready() -> void:
	_input_line.text_submitted.connect(_line_submitted)
	
	global_position = Vector2(0.0, get_viewport_rect().size.y)
	
	register_command("quit", _quit)
	
	# disable in non-editor builds
	if not OS.has_feature("editor"):
		set_process_input(false)
		set_process(false)
	
	
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed:
		if key.keycode == KEY_SLASH:
			_activate(not _active)
			accept_event()
		if key.keycode == KEY_ESCAPE and _active:
			_activate(false)
			accept_event()
			
		if key.keycode == KEY_UP:
			_cycle_history(-1)
			accept_event()
		if key.keycode == KEY_DOWN:
			_cycle_history(1)
			accept_event()
			
		
func _process(delta: float) -> void:
	var target := Vector2(0.0, get_viewport_rect().size.y - size.y) if _active else Vector2(0.0, get_viewport_rect().size.y)
	global_position = global_position.move_toward(target, SPEED * delta)


# Public Functions
func register_command(handle: String, callable: Callable) -> void:
	for com : Command in _commands:
		if com.handle == handle:
			return
	
	_commands.push_back(Command.new(handle, callable))


# Private Functions
func _activate(active := true) -> void:
	_active = active
	
	if active:
		_input_line.grab_focus()
	else:
		get_viewport().gui_release_focus()
		
		
func _line_submitted(text: String) -> void:
	_input_line.clear()
	_history_index = -1
	_parse_input(text)
	
	
func _parse_input(input: String) -> void:
	var handle := input.substr(0, input.find(" "))
	for com : Command in _commands:
		if com.handle == handle:
			var args := input.substr(input.find(" ") + 1).split(" ")
			com.callable.call(args)
			_append_history(input)
			_output(handle)
			return
	
	_output("unrecognised command: " + handle)
	

func _append_history(line: String) -> void:
	# remove oldest entry if this is a duplicate
	var index := _history.find(line)
	if index > -1:
		_history.remove_at(index)
	
	# add this line to the history	
	_history.push_back(line)
	
	
func _cycle_history(step: int) -> void:
	if _history.is_empty():
		return
	
	_history_index = wrapi(_history_index + step, 0, _history.size())
	_input_line.text = _history[_history_index]
	_input_line.caret_column = _input_line.text.length()
		
		
func _output(text: String) -> void:
	_output_line.text = text
	
	
func _quit(args: PackedStringArray) -> void:
	get_tree().quit()
	
