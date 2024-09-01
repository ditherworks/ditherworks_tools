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
@export var _output : ConsoleOutput
@export var _input_line : LineEdit
@export var _panel : PanelContainer

var _active := false
var _commands : Array[Command]


# Default Callbacks
func _ready() -> void:
	_input_line.text_submitted.connect(submit_command)
	
	global_position = Vector2(0.0, get_viewport_rect().size.y)
		
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
	var height := _panel.size.y
	var target := Vector2(0.0, get_viewport_rect().size.y - height) if _active else Vector2(0.0, get_viewport_rect().size.y)
	global_position = global_position.move_toward(target, SPEED * delta)


# Public Functions
func register_command(handle: String, callable: Callable) -> void:
	for com : Command in _commands:
		if com.handle == handle:
			return
	
	_commands.push_back(Command.new(handle, callable))
	
	
func submit_command(text: String) -> void:
	_input_line.clear()
	_parse_input(text)
	
	
func print_line(line: String, color := Color.WHITE) -> void:
	_output.print_line(line, color)


# Private Functions
func _activate(active := true) -> void:
	_active = active
	
	if active:
		_input_line.grab_focus()
	else:
		get_viewport().gui_release_focus()
		
	
func _cycle_history(direction: int) -> void:
	_input_line.text = _output.cycle_history(direction)
	_input_line.caret_column = _input_line.text.length()
		
			
func _parse_input(input: String) -> void:
	var handle := _extract_handle(input)
	for com : Command in _commands:
		if com.handle == handle:
			com.callable.call(_extract_args(input))
			_output.append_history(input)
			_output.print_line(input)
			return
	
	_output.print_line("unrecognised command: " + handle, Color.ORANGE_RED)
	
	
func _extract_handle(line: String) -> String:
	return line.substr(0, line.find(" "))
	
	
func _extract_args(line: String) -> PackedStringArray:
	var start := line.find(" ")
	if start == -1:
		return PackedStringArray([""])
	else:
		return line.substr(start + 1).split(" ")
		
