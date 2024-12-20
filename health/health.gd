@icon("health.svg")
class_name Health
extends Node3D


# Signals
signal value_changed(amount: float)


# Constants
const ROUND_TO_WHOLE := false


# Members
@export_group("Config")
@export var _max_value := 100.0


var _current_value := _max_value
var _hitboxes : Array

var _damage_requests : Array[Dictionary]


# Default Callbacks	
func _ready() -> void:
	_hitboxes = _get_all_hitboxes(get_parent_node_3d())
	
	for hitbox : HitBox in _hitboxes:
		(hitbox as HitBox).connect_to_health(self)
	
			
# Public Functions
func request_overlap_hurt(damage: float, hitboxes: Array, creator: Node3D) -> void:
	# find the highest damage result
	var chosen_damage := -1.0
	var chosen_hitbox : HitBox
	
	for hitbox : HitBox in hitboxes:
		var calculated := hitbox.calculate_damage(damage)
		if calculated > chosen_damage:
			chosen_damage = calculated
			chosen_hitbox = hitbox
	
	# apply the chosen hurt
	if chosen_hitbox:
		hurt(chosen_damage, chosen_hitbox.global_position, Vector3.ZERO, creator)
	
	
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
	
