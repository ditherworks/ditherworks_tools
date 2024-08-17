class_name Player
extends CharacterBody3D


# Enums and Constants
const SPEED := 4.0
const SENSITIVITY := 0.3
const LOOK_LIMIT := deg_to_rad(89.0)


# Export Members
@export var _camera_path : NodePath
@export var _raycast_path : NodePath
@export var _state_machine_path : NodePath

@export_group("Externals")
@export var _spark_fx : PackedScene


# Private Members
@onready var _camera := get_node(_camera_path) as Camera3D
@onready var _raycast := get_node(_raycast_path) as RayCast3D
@onready var _state_machine := get_node(_state_machine_path) as StateMachine
@onready var _gravity := ProjectSettings.get_setting("physics/3d/default_gravity") as float

var _move_input : Vector3
var _mouse_input : Vector2


# Default Callbacks
func _process(delta: float) -> void:
	_mouse_look()
	
	
func _physics_process(delta: float) -> void:
	_apply_physics(delta)
	
	if Input.is_key_pressed(KEY_0):
		get_tree().paused = not get_tree().paused
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		g_game.pause(true)
		get_viewport().set_input_as_handled()
	

# Public Functions	
func set_move_input(input: Vector3) -> void:
	_move_input = input.limit_length(1.0) * Vector3(1.0, 0.0, 1.0)
	
	
func update_look_input(look_input: Vector2) -> void:
	_mouse_input += look_input
	
	
func get_flat_velocity() -> Vector3:
	return velocity * Vector3(1.0, 0.0, 1.0)
	
	
func shoot() -> void:
	if _raycast.is_colliding():
		SpawnedFX3D.spawn_aimed(_spark_fx, self, _raycast.get_collision_point(), _raycast.get_collision_normal())
		g_lines.draw_line(_raycast.global_position, _raycast.get_collision_point(), Color.ORANGE_RED, 1.0)
		g_lines.draw_point(_raycast.get_collision_point(), 0.1, Color.RED, 1.0)
		
		if _raycast.get_collider() is HitBox:
			var hitbox := _raycast.get_collider() as HitBox
			hitbox.hurt(10.0, _raycast.get_collision_point(), _raycast.get_collision_normal(), self)
	else:
		var tip := _raycast.global_position + (_raycast.global_basis * _raycast.target_position)
		g_lines.draw_line(_raycast.global_position, tip, Color.ORANGE_RED, 1.0)


# Private Functions
func _apply_physics(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y -= (_gravity * delta)
		
	# movement
	var vertical := Vector3.UP * velocity.y
	velocity = (global_basis * (_move_input * SPEED)) + vertical
	move_and_slide()
	g_lines.draw_ray(global_position + Vector3(0.0, 0.1, 0.0), -velocity * delta, Color.GREEN, 1.0)
	
	
func _mouse_look() -> void:
	rotate_y(-_mouse_input.x * SENSITIVITY)
	var pitch := _camera.rotation.x - (_mouse_input.y * SENSITIVITY)
	_camera.rotation.x = clampf(pitch, -LOOK_LIMIT, LOOK_LIMIT)
	
	# clear mouse input buffer, ready for next frame
	_mouse_input = Vector2.ZERO
	
