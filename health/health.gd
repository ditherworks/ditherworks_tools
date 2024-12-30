@icon("health.svg")
class_name Health
extends Node3D


# Signals
signal value_changed(info: HurtInfoBase)


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
func overlap_hurt(info: HurtInfoBase, hitboxes: Array, hurtbox: HurtBox) -> float:
	# find the highest damage result
	var chosen_damage := -1.0
	var chosen_hitbox : HitBox
	
	for hitbox : HitBox in hitboxes:
		var calculated := hitbox.calculate_damage(info.amount)
		if calculated > chosen_damage:
			chosen_damage = calculated
			chosen_hitbox = hitbox
	
	# apply the chosen hurt
	if chosen_hitbox:
		info.hitbox = chosen_hitbox
		info.amount = chosen_damage
		hurt(info)
		return chosen_damage
		
	return 0.0
	
	
func hurt(info: HurtInfoBase) -> float:
	if _current_value <= 0.0:
		return 0.0
	
	if _max_value > 0.0:
		_current_value -= info.amount
		_current_value = clampf(_current_value, 0.0, _max_value)
		
	if ROUND_TO_WHOLE:
		_current_value = floorf(_current_value)
	
	value_changed.emit(info)
	
	return info.amount
	

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
	
