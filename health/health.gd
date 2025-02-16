@icon("health.svg")
class_name Health
extends Node3D


# Signals
signal value_changed(previous_value: float, new_value: float)
signal damage_taken(info: HurtInfoBase)
signal died()


# Constants
const ROUND_TO_WHOLE := false


# Members
@export_group("Config")
@export var _max_value := 100.0


var _current_value := _max_value
var _hitboxes : Array

var _damage_requests : Array[Dictionary]
var _dodge_buffer := 0.0


# Default Callbacks	
func _ready() -> void:
	_hitboxes = _get_all_hitboxes(get_parent_node_3d())
	
	for hitbox : HitBox in _hitboxes:
		(hitbox as HitBox).connect_to_health(self)
		
		
func _physics_process(delta: float) -> void:
	if _dodge_buffer > 0.0:
		_dodge_buffer -= delta
	
			
# Public Functions
func overlap_hurt(info: HurtInfoBase, hitboxes: Array, hurtbox: HurtBox) -> HurtInfoBase:
	# find the highest damage result
	var highest_damage := -1.0
	var chosen_hitbox : HitBox
	
	for hitbox : HitBox in hitboxes:
		if info.get_calculated_damage() > highest_damage:
			highest_damage = info.get_calculated_damage()
			chosen_hitbox = hitbox
	
	# apply the chosen hurt
	if chosen_hitbox:
		info.hitbox = chosen_hitbox
		hurt(info)
		return info
		
	return null
	
	
func hurt(info: HurtInfoBase) -> HurtInfoBase:	
	if _current_value <= 0.0 or _dodge_buffer > 0.0:
		return null
	
	if _max_value > 0.0:
		_current_value -= info.get_calculated_damage()
		_current_value = clampf(_current_value, 0.0, _max_value)
		
	if ROUND_TO_WHOLE:
		_current_value = floorf(_current_value)
	
	damage_taken.emit(info)
	value_changed.emit(_current_value + info.get_calculated_damage(), _current_value)
	if _current_value <= 0.0:
		died.emit()
	
	return info
	
	
func dodge_damage(duration : float) -> void:
	if duration > _dodge_buffer:
		_dodge_buffer = duration
	

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
	
