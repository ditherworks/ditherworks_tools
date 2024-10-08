class_name Game
extends Node


# Signals
# Enums
# Constants
# Members
@export var _hud : Hud
@export var _pause : PauseScreen
@export var _front_end : FrontEnd
@export var _transition : Transition

@export_group("Config")
@export var _start_in_game := false


var _world : Node3D


# Default Callbacks
func _ready() -> void:
	g_console.register_command("quit", _quit)
	g_console.register_command("fullscreen", _fullscreen)
	
	_prep_defaults()
		
	if _start_in_game:
		switch_to_world(false)
	else:
		switch_to_front_end(false)
		
		
func _unhandled_input(event: InputEvent) -> void:
	var key := event as InputEventKey
	if key and key.pressed and key.keycode == KEY_F5:
		g_console.submit_command("fullscreen")
		
	
# Public Functions
func pause(enable: bool) -> void:
	get_tree().paused = enable
	_hud.visible = not enable
	_pause.visible = enable
	_pause.process_mode = Node.PROCESS_MODE_INHERIT if enable else Node.PROCESS_MODE_DISABLED
		
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if enable else Input.MOUSE_MODE_CAPTURED
	
	
func switch_to_front_end(use_transition := true) -> void:
	get_tree().paused = false
	_world.process_mode = Node.PROCESS_MODE_DISABLED
	
	if use_transition and _transition:
		_transition.transition_out()
		await _transition.out_complete
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	_hud.visible = false
	
	_set_state(_pause, Node.PROCESS_MODE_DISABLED)
	_set_state(_front_end, Node.PROCESS_MODE_INHERIT)
	_set_state(_world, Node.PROCESS_MODE_DISABLED)
	
	if use_transition and _transition:
		_transition.transition_in()
		

func switch_to_world(use_transition := true) -> void:
	_front_end.process_mode = Node.PROCESS_MODE_DISABLED
	
	if use_transition and _transition:
		_transition.transition_out()
		await _transition.out_complete

	_hud.visible = true
	
	_set_state(_pause, Node.PROCESS_MODE_DISABLED)
	_set_state(_front_end, Node.PROCESS_MODE_DISABLED)
	_set_state(_world, Node.PROCESS_MODE_PAUSABLE)
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	get_tree().paused = false
	if use_transition and _transition:
		_transition.transition_in()
		
		
func take_screenshot(show_hud := false) -> void:
	var hud_got_hidden := _hud.visible and not show_hud
	_hud.visible = show_hud
	
	await RenderingServer.frame_post_draw
	
	var image := get_viewport().get_texture().get_image()
	var path := "user://screen_" + Utils.get_unique_timestamp() + ".png"
	image.save_png(path)
	prints("screenshot_taken...", path)
	
	if hud_got_hidden:
		_hud.visible = true 
		
				
# Private Functions
func _prep_defaults() -> void:
	if not _hud:
		_hud = Hud.new()
		add_child(_hud)
		
	if not _pause:
		_pause = PauseScreen.new()
		add_child(_pause)
	
	if not _front_end:
		_front_end = FrontEnd.new()
		add_child(_front_end)
		
	var root := get_tree().root
	_world = root.get_child(root.get_child_count() - 1) as Node3D
	if not _world:
		_world = Node3D.new()
		add_child(_world)
		
	process_mode = Node.PROCESS_MODE_ALWAYS


func _set_state(element: Node, mode: ProcessMode) -> void:
	element.visible = false if (mode == PROCESS_MODE_DISABLED) else true
	element.process_mode = mode
	element.set_process_input(false if mode == PROCESS_MODE_DISABLED else true)
	

func _quit(args: PackedStringArray) -> void:
	get_tree().quit()
	

func _fullscreen(args: PackedStringArray) -> void:
	if args[0] == "":
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		if int(args[0]) <= 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
