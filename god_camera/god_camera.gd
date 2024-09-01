class_name GodCamera
extends Camera3D


# Signals
# Enums
# Constants
const ACTION_NAME := "god_cam"
const MOVE_SPEED := 5.0
const LOOK_SPEED := 3.0


# Members
# Default Callbacks
func _ready() -> void:
	clear_current()
	_create_input_action()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func _process(delta: float) -> void:
	_proces_input(delta)
	

# Public Functions	
# Private Functions
func _proces_input(delta: float) -> void:
	if Input.is_action_just_released(ACTION_NAME):
		_activate(not current)
		
	# movement input
	var stick := Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y))
	stick = Utils.stick_deadzone_adjust(stick)
	if Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
		global_position += global_basis * Vector3(stick.x * MOVE_SPEED, -stick.y * MOVE_SPEED, 0.0) * delta	
	else:
		global_position += global_basis * Vector3(stick.x * MOVE_SPEED, 0.0, stick.y * MOVE_SPEED) * delta
	
	# look input
	var yaw_input := Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	rotate_y(-Utils.axis_deadzone_adjust(yaw_input, 0.2) * LOOK_SPEED * delta)
	
	var pitch := rotation.x
	var pitch_input := Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	pitch_input = Utils.axis_deadzone_adjust(pitch_input, 0.2)
	pitch += -pitch_input * LOOK_SPEED * delta
	pitch = clampf(pitch, deg_to_rad(-89.0), deg_to_rad(89.0))
	rotation.x = pitch
	
	
func _activate(enable: bool) -> void:
	if enable:
		_overrule_camera(get_viewport().get_camera_3d())
	else:
		clear_current()
		
	get_tree().paused = enable	#! this clashes with my pause menu slightly (perhaps don't have game rely on paused flag for logic)


func _overrule_camera(camera: Camera3D) -> void:
	global_position = camera.global_position
	global_rotation = camera.global_rotation
	
	global_position += camera.global_basis.z * 2.0
	make_current()


func _create_input_action() -> void:
	InputMap.add_action(ACTION_NAME)
	
	var joy_event := InputEventJoypadButton.new()
	joy_event.button_index = JOY_BUTTON_LEFT_STICK
	InputMap.action_add_event(ACTION_NAME, joy_event)
		
			
