class_name ElasticTracker
extends Marker3D


# Signals
# Enums
# Constants
# Members
@export var _stiffness := 0.4
@export var _friction := 0.6
@export var _distance_limit := 4.0


var _target_node : Node3D
var _target_position : Vector3


# Default Callbacks
func _ready() -> void:
	top_level = true


func _physics_process(delta: float) -> void:
	if _target_node:
		_target_position = _target_node.global_position
	global_position = _elastic_follow(global_position, _target_position, _stiffness, _friction)
	
	var offset := global_position - _target_position
	global_position = _target_position + offset.limit_length(_distance_limit)
		
	
# Public Functions
func set_target_node(node3D: Node3D) -> void:
	_target_node = node3D
	
	
func set_target_position(location : Vector3) -> void:
	_target_position = location
	_target_node = null
	
	
func snap_to_target() -> void:
	global_position = _target_node.global_position if _target_node else _target_position 
	
	
# Private Functions
func _elastic_follow(start : Vector3, target : Vector3, stiffness : float, friction : float) -> Vector3:
	var offset := target - start
	var movement := offset * stiffness
	movement -= (movement * friction)
	return start + movement
