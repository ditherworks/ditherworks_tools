class_name CharacterCapsule
extends CollisionShape3D


# TODO
# perform collision checks before growing upwards (prevents standing when underneath something)


# Signals
# Enums
# Constants
const RATE := 5.0


# Members
var _capsule : CapsuleShape3D
var _target_height := 1.8
var _desired_radius : float
var _default_height : float


# Default Callbacks
func _ready() -> void:
	if not shape.resource_local_to_scene:
		shape = shape.duplicate()
	_capsule = shape as CapsuleShape3D
	_desired_radius = _capsule.radius
	_default_height = _capsule.height
	
	
func _physics_process(delta: float) -> void:
	# update size (and position)
	if not is_equal_approx(_target_height, _capsule.height):
		_capsule.height = move_toward(_capsule.height, _target_height, RATE * delta)
		if _capsule.height <= (_desired_radius * 2.0):
			_capsule.radius = _capsule.height / 2.0
		else:
			_capsule.radius = _desired_radius
		position.y = _capsule.height * 0.5
	

# Public Functions
func reset_height() -> void:
	set_height(_default_height)
		
	
func set_height(height : float) -> void:
	_target_height = height
	
	
# Private Functions
