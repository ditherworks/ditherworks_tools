class_name Player
extends Character


# Enums and Constants
const SPEED := 4.0
const SENSITIVITY := 0.3
const LOOK_LIMIT := deg_to_rad(89.0)


# Export Members
@export var _camera : Camera3D
@export var _bullet_cast : BulletCast
@export var _state_machine : StateMachine
@export var _melee_hurtbox : HurtBox


# Members
var _mouse_input : Vector2


# Default Callbacks
func _physics_process(delta: float) -> void:
	super(delta)
	
	_mouse_look()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		g_game.pause(true)
		get_viewport().set_input_as_handled()
		
	if event.is_action_pressed("melee") and _melee_hurtbox:
		_melee_hurtbox.activate(10.0, 0.1, self)
		print("swish")
	

# Public Functions	
func update_look_input(look_input: Vector2) -> void:
	_mouse_input += look_input
	
	
func get_flat_velocity() -> Vector3:
	return velocity * Vector3(1.0, 0.0, 1.0)


# Private Functions
func _mouse_look() -> void:	
	_set_rotation_heading(-global_basis.z.rotated(Vector3.UP, -_mouse_input.x * SENSITIVITY))
	
	var pitch := _camera.rotation.x - (_mouse_input.y * SENSITIVITY)
	var limit := deg_to_rad(89.0)
	_camera.rotation.x = clampf(pitch, -limit, limit)
	
	# clear mouse input buffer, ready for next frame
	_mouse_input = Vector2.ZERO
	
