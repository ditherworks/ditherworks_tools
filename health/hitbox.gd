class_name HitBox
extends Area3D


# Config Variables
@export var _multiplier := 1.0


# Private Variables
var _health : Health


# Default Callbacks

# Public Functions
func connect_to_health(health: Health) -> void:
	_health = health


func hurt(amount: float, point: Vector3, normal: Vector3, creator: Node3D) -> bool:
	if _health:
		return _health.hurt(calculate_damage(amount), point, normal, creator)
	return false
	

func calculate_damage(hurt_amount: float) -> float:
	if not _health or _health.is_dead():
		return 0.0
	return hurt_amount * _multiplier
	
	
func request_damage(amount: float, creator: Node3D) -> void:
	if _health:
		_health.request_damage(calculate_damage(amount), self, creator)
		
