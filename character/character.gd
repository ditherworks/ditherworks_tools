class_name Character
extends CharacterBody3D


# Signals
signal jumped()
signal landed(fall_distance: float)


# Enums
# Constants
# Members
@export_group("Physics")
@export var _acceleration := 60.0
@export var _deceleration := 40.0
@export var _air_modifier := 0.5

@export var _gravity_multiplier := 2.0
#@export var _max_fall_speed := 20.0


@onready var _gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float


var _move_direction : Vector3
var _move_speed := 3.0

var _fixed_motion := Vector3.ZERO

var _fall_distance := 0.0


# Default Callbacks
func _physics_process(delta: float) -> void:
	_apply_input_forces(delta)
	_apply_gravity(delta)
	_update_motion(delta)
		
	
# Public Functions
func get_flat_velocity() -> Vector3:
	return velocity * Vector3(1.0, 0.0, 1.0)
	
	
func get_movement_heading() -> Vector3:
	var flat_velocity := velocity * Vector3(1.0, 0.0, 1.0)
	if flat_velocity.is_zero_approx():
		return -global_basis.z
		
	return flat_velocity.normalized()
	
	
func set_fixed_motion(motion: Vector3) -> void:
	_fixed_motion = motion
	
	
func set_move_direction(input: Vector3) -> void:
	_move_direction = input
	
	
func set_speed(move_speed: float, accel := -1.0, decel := -1.0) -> void:
	_move_speed = move_speed
	_acceleration = accel if accel > 0.0 else _acceleration
	_deceleration = decel if decel > 0.0 else _deceleration
	

func face_in_direction(direction: Vector3) -> void:
	var heading := direction * Vector3(1.0, 0.0, 1.0)
	if heading.length() > 0.0:
		look_at(global_position + heading.normalized())
	
	
func rotate_to_direction(direction: Vector3, rotate_amount: float) -> void:
	var forward := -global_basis.z
	var angle := forward.signed_angle_to(direction.normalized(), Vector3.UP)
	var rate := deg_to_rad(rotate_amount)
	rotate_y(clampf(angle, -rate, rate))
	
		
func set_gravity_multiplier(multiplier: float) -> void:
	_gravity_multiplier = multiplier
	
	
func apply_impulse(impulse : Vector3) -> void:
	velocity += impulse
	
	
func jump(force: float) -> void:
	velocity.y = force
	jumped.emit()
	
	
func is_moving() -> bool:
	var flat_velocity := velocity * Vector3(1.0, 0.0, 1.0)
	return flat_velocity.length() > 0.1 or not _fixed_motion.is_zero_approx()


# Private Functions
func _apply_input_forces(delta: float) -> void:
	var input := _move_direction * Vector3(1.0, 0.0, 1.0)
	input = input.limit_length()
	
	# if there's a fixed/root motion, ignore physics input
	if not _fixed_motion.is_zero_approx():
		input = Vector3.ZERO
	
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
		

func _update_motion(delta: float) -> void:
	var previously_airborne := not is_on_floor()
	
	# temporarily account for requested fixed/root motion
	var previous_velocity := velocity
	velocity += _fixed_motion
	
	move_and_slide()
	
	# revert all motion values
	velocity = previous_velocity
	_fixed_motion = Vector3.ZERO
	
	# track falling distance
	if velocity.y < 0.0:
		_fall_distance += abs(velocity.y * delta)
		
	# respond to landing
	if is_on_floor():
		velocity.y = 0.0
		if previously_airborne:
			landed.emit(_fall_distance)
	
	# reset falling distance
	if velocity.y >= 0.0:
		_fall_distance = 0.0
