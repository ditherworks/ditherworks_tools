class_name HurtInfoBase
extends RefCounted


# Members
var amount: float
var point: Vector3
var hitbox: HitBox
var creator: Node3D


# Initializer
func _init(hit_amount: float, hit_point: Vector3, hit_hitbox: HitBox, hit_creator: Node3D) -> void:
	amount = hit_amount
	point = hit_point
	hitbox = hit_hitbox
	creator = hit_creator


func get_calculated_damage() -> float:
	if hitbox:
		return amount * hitbox._multiplier
		
	return amount
