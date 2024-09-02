class_name ConsoleOutput
extends VBoxContainer


# Signals
# Enums
# Constants
const LINE_COUNT_MAX := 5
const DISPLAY_TIME := 3.0
const FADE_TIME := 2.0

# Members
var _history : Array[String]
var _history_index := -1

var _life := 0.0


# Default Callbacks
func _ready() -> void:
	_init_lines(LINE_COUNT_MAX)
	
	visibility_changed.connect(_on_visibility_changed)
	visible = false
	
	
func _process(delta: float) -> void:
	if _life <= 0.0:
		return
		
	_life -= delta
	if _life <= 0.0:
		visible = false
	else:
		var alpha := clampf(inverse_lerp(0.0, FADE_TIME, _life), 0.0, 1.0)
		modulate = Color(1.0, 1.0, 1.0, alpha)
	
	
# Public Functions
func print_line(line: String, color := Color.WHITE) -> void:
	visible = true
	_life = DISPLAY_TIME + FADE_TIME
	
	var label := get_child(0) as Label
	label.text = line
	label.add_theme_color_override("font_color", color)
	move_child(label, LINE_COUNT_MAX - 1)
	
	_history_index = -1
	
	
func append_history(line: String) -> void:
	var index := _history.find(line)
	if index > -1:
		_history.remove_at(index)
	
	_history.push_back(line)


func cycle_history(step: int) -> String:
	if _history.is_empty():
		return ""
	
	_history_index = _history_index + step
	if _history_index < 0:
		_history_index = _history.size() - 1
	if _history_index >= _history.size():
		_history_index = 0
		
	return _history[_history_index]
		
		
# Private Functions
func _init_lines(count: int) -> void:
	var label := get_child(0) as Label
	label.text = ""
	
	for i in count - 1:
		add_child(label.duplicate())
	

func _on_visibility_changed() -> void:
	if not visible:
		for label : Label in get_children():
			label.text = ""
