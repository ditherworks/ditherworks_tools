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


func hurt(info: HurtInfoBase) -> HurtInfoBase:
	if not info.hitbox:
		info.hitbox = self
		
	if _health:
		return _health.hurt(info)
	
	return null
	
