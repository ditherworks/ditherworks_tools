@icon("res://health/health.svg")
class_name Health
extends Node3D


# Signals
signal value_changed(amount: float)


# Constants
const ROUND_TO_WHOLE := false


# Config Values
@export_group("Internals")
@export var _hitbox_root_path : NodePath

@export_group("Config")
@export var _max_value := 100.0


# Member Variables
var _current_value := _max_value
var _hitboxes : Array


# Default Callbacks	
func _ready() -> void:
	if _hitbox_root_path.is_empty():
		_hitboxes = _get_all_hitboxes(self)
	else:
		_hitboxes = _get_all_hitboxes(get_node(_hitbox_root_path))
		
	for hitbox : HitBox in _hitboxes:
		(hitbox as HitBox).connect_to_health(self)
	
			
# Public Functions
func hurt(amount: float, point: Vector3, normal: Vector3, creator: Node3D) -> bool:
	if _current_value <= 0.0:
		return false
	
	if _max_value > 0.0:
		_current_value -= amount
		_current_value = clampf(_current_value, 0.0, _max_value)
		
	if ROUND_TO_WHOLE:
		_current_value = floorf(_current_value)
	
	value_changed.emit(amount)
	
	return true


func is_dead() -> bool:
	return _current_value <= 0.0
	
	
func get_ratio_value() -> float:
	return _current_value / _max_value
	

# Private Functions
func _get_all_hitboxes(node: Node, hitboxes := []) -> Array:
	# recursive search to gather all hitboxes underneath a specific node
	if node is HitBox:
		hitboxes.push_back(node)
		
	for child in node.get_children():
		hitboxes = _get_all_hitboxes(child, hitboxes)
		
	return hitboxes
