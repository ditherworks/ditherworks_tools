class_name Character
extends CharacterBody3D


# Signals
# Enums
# Constants
# Members
@export_group("Physics")
@export var _acceleration := 60.0
@export var _deceleration := 40.0
@export var _air_modifier := 0.5
@export var _rotate_rate := 40.0

@export var _gravity_multiplier := 2.0
#@export var _max_fall_speed := 20.0


@onready var _gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float


var _move_direction : Vector3
var _rotation_heading := Vector3.FORWARD
var _move_speed := 3.0


# Default Callbacks
func _physics_process(delta: float) -> void:
	_apply_input_forces(delta)
	_apply_gravity(delta)
	move_and_slide()
	
	if is_on_floor():
		velocity.y = 0.0
		
	_update_rotation(delta)
		
	
# Public Functions
func get_flat_velocity() -> Vector3:
	return velocity * Vector3(1.0, 0.0, 1.0)
	
	
func get_movement_heading() -> Vector3:
	var flat_velocity := velocity * Vector3(1.0, 0.0, 1.0)
	if flat_velocity.is_zero_approx():
		return -global_basis.z
		
	return flat_velocity.normalized()
	
	
func set_move_direction(input: Vector3, move_speed: float, accel := -1.0, decel := -1.0) -> void:
	_move_direction = input
	_move_speed = move_speed
	_acceleration = accel if accel > 0.0 else _acceleration
	_deceleration = decel if decel > 0.0 else _deceleration
	
	
func set_rotation_heading(heading: Vector3, rate := -1.0) -> void:
	if heading.is_zero_approx():
		return
		
	_rotation_heading = heading.normalized()
	
	if rate > 0.0:
		_rotate_rate = rate
	else:
		look_at(global_position + heading.normalized())
		
	
func set_gravity_multiplier(multiplier: float) -> void:
	_gravity_multiplier = multiplier


# Private Functions
func _apply_input_forces(delta: float) -> void:
	var input := _move_direction * Vector3(1.0, 0.0, 1.0)
	input = input.limit_length()
	
	# break velocity into lateral and vertical
	var lateral := velocity * Vector3(1.0, 0.0, 1.0)
	var vertical := velocity - lateral
	
	var desired_speed := Utils.deadzone_adjust_float(input.length()) * _move_speed
	var speed_limit := maxf(desired_speed, lateral.length())
	var multiplier := 1.0 if is_on_floor() else _air_modifier
	
	# apply acceleration and clamp to speed limit
	if not input.is_zero_approx():
		var force := input.normalized() * (_acceleration * delta * multiplier)
		lateral += force
		lateral = lateral.limit_length(speed_limit)
	
	# apply deceleration if we're over speed or not pushing a direction
	if input.is_zero_approx() or (lateral.length() > speed_limit and is_on_floor()):
		var force := -lateral.normalized() * _deceleration * delta * multiplier
		lateral += force
		
		# prevent friction moving us backwards
		if lateral.normalized().dot(force.normalized()) > 0.0:
			lateral = Vector3.ZERO
			
	# recombine velocity components
	velocity = lateral + vertical
	

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta * _gravity_multiplier
		
		
func _update_rotation(delta: float) -> void:
	var rate := deg_to_rad(_rotate_rate * delta)
	var forward := -global_basis.z
	var angle := forward.signed_angle_to(_rotation_heading.normalized(), Vector3.UP)
	rotate_y(clampf(angle, -rate, rate))

	
func _jump(force: float) -> void:
	velocity.y = force
	
