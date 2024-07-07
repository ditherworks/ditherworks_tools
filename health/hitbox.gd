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
		return _health.hurt(amount * _multiplier, point, normal, creator)
	return false
