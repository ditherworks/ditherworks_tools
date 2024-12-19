class_name Player
extends Character


# Enums and Constants
const SPEED := 4.0
const SENSITIVITY := 0.2


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
				
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		_mouse_input += motion.screen_relative * SENSITIVITY
	

# Public Functions	
func get_flat_velocity() -> Vector3:
	return velocity * Vector3(1.0, 0.0, 1.0)


# Private Functions
func _mouse_look() -> void:
	if not _mouse_input.is_zero_approx():
		face_in_direction(-global_basis.z.rotated(Vector3.UP, deg_to_rad(-_mouse_input.x)))
		
		var pitch := _camera.rotation.x - deg_to_rad(_mouse_input.y)
		var limit := deg_to_rad(89.0)
		_camera.rotation.x = clampf(pitch, -limit, limit)
	
	# clear mouse input buffer, ready for next frame
	_mouse_input = Vector2.ZERO
	
