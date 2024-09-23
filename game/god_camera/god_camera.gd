class_name GodCamera
extends Camera3D


# Signals
# Enums
# Constants
const ACTION_TOGGLE := "god_cam"
const ACTION_SCREENSHOT := "screenshot"
const ACTION_SPEED_UP := "speed_up"

const MOVE_SPEED := 5.0
const LOOK_SPEED := 3.0
const MOUSE_SENSITIVITY := 0.3


# Members
var _mouse_input := Vector2.ZERO


# Default Callbacks
func _ready() -> void:
	clear_current()
	_create_input_actions()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func _process(delta: float) -> void:
	_process_input(delta)
	
	
func _input(event: InputEvent) -> void:
	var mouse := event as InputEventMouseMotion
	if mouse:
		_mouse_input += mouse.screen_relative
				

# Public Functions	
# Private Functions
func _process_input(delta: float) -> void:
	if Input.is_action_just_pressed(ACTION_TOGGLE):
		_activate(not current)
		
	# movement input
	var movement := Vector3()
	movement.x = -1.0 if Input.is_key_pressed(KEY_A) else 1.0 if Input.is_key_pressed(KEY_D) else 0.0
	movement.z = -1.0 if Input.is_key_pressed(KEY_W) else 1.0 if Input.is_key_pressed(KEY_S) else 0.0
	movement.y = -1.0 if Input.is_key_pressed(KEY_Q) else 1.0 if Input.is_key_pressed(KEY_E) else 0.0
	
	if is_zero_approx(movement.x):
		movement.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	if is_zero_approx(movement.y):
		if Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
			movement.y = -Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	if is_zero_approx(movement.z):
		if not Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
			movement.z = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
			
	movement = Utils.deadzone_adjust_vec3(movement)
	var speed := MOVE_SPEED * 2.0 if Input.is_action_pressed(ACTION_SPEED_UP) else MOVE_SPEED
	global_position += global_basis * (movement * speed * delta)
	
	# look input
	var yaw_input := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	rotate_y(-Utils.deadzone_adjust_float(yaw_input, 0.2) * LOOK_SPEED * delta)
	rotate_y(-_mouse_input.x * deg_to_rad(MOUSE_SENSITIVITY))
	
	var pitch := rotation.x
	var pitch_input := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	pitch_input = Utils.deadzone_adjust_float(pitch_input, 0.2)
	pitch += -pitch_input * LOOK_SPEED * delta
	pitch -= _mouse_input.y * deg_to_rad(MOUSE_SENSITIVITY)
	pitch = clampf(pitch, deg_to_rad(-89.0), deg_to_rad(89.0))
	rotation.x = pitch
	
	_mouse_input = Vector2.ZERO
	
	# screenshotter
	if Input.is_action_just_pressed(ACTION_SCREENSHOT):
		g_game.take_screenshot()
	
	
func _activate(enable: bool) -> void:
	if enable:
		if get_tree().paused:
			return
		_overrule_camera(get_viewport().get_camera_3d())
		g_game._hud.visible = false		
	else:
		clear_current()
		g_game._hud.visible = true
		
	get_tree().paused = enable


func _overrule_camera(camera: Camera3D) -> void:
	global_position = camera.global_position
	global_rotation = camera.global_rotation
	
	global_position += camera.global_basis.z * 2.0
	make_current()


func _create_input_actions() -> void:
	InputMap.add_action(ACTION_TOGGLE)
	var joy_button := InputEventJoypadButton.new()
	joy_button.button_index = JOY_BUTTON_LEFT_STICK
	InputMap.action_add_event(ACTION_TOGGLE, joy_button)
	var key := InputEventKey.new()
	key.keycode = KEY_F12
	InputMap.action_add_event(ACTION_TOGGLE, key)
	
	InputMap.add_action(ACTION_SCREENSHOT)
	joy_button = InputEventJoypadButton.new()
	joy_button.button_index = JOY_BUTTON_Y
	InputMap.action_add_event(ACTION_SCREENSHOT, joy_button)	
	var mouse_button := InputEventMouseButton.new()
	mouse_button.button_index = MOUSE_BUTTON_MIDDLE
	InputMap.action_add_event(ACTION_SCREENSHOT, mouse_button)
	
	InputMap.add_action(ACTION_SPEED_UP)
	joy_button = InputEventJoypadButton.new()
	joy_button.button_index = JOY_BUTTON_B
	InputMap.action_add_event(ACTION_SPEED_UP, joy_button)	
	key = InputEventKey.new()
	key.keycode = KEY_SHIFT
	InputMap.action_add_event(ACTION_SPEED_UP, key)
	
