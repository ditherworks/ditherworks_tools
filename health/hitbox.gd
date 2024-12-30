class_name HitBox
extends Area3D


# Config Variables
@export var _multiplier := 1.0


# Private Variables
var _health : Health


# Default Callbacks
func _ready() -> void:
	monitoring = false
	

# Public Functions
func connect_to_health(health: Health) -> void:
	_health = health


func hurt(amount: float, point: Vector3, creator: Node3D) -> float:
	if not _health:
		return 0.0
		
	var damage := calculate_damage(amount)
	return _health.hurt(HurtInfoBase.new(damage, point, self, creator))
	

func calculate_damage(hurt_amount: float) -> float:
	if not _health or _health.is_dead():
		return 0.0
	return hurt_amount * _multiplier
			
