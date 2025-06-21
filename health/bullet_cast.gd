class_name BulletCast
extends RayCast3D


# Signals
# Enums
# Constants
# Members


# Default Callbacks
func _ready() -> void:
	enabled = false
	collide_with_areas = true
	
	
# Public Functions
func shoot() -> bool:
	clear_exceptions()
	
	while _cast_for_collision():
		Fx.spawn_aimed("spark_fx", get_collision_point(), get_collision_normal())
		
		var hitbox := get_collider() as HitBox
		if hitbox:
			hitbox.hurt(HurtInfoBase.new(10.0, get_collision_point(), hitbox, self))
			return true
		
		if get_collider() is Area3D:
			add_exception(get_collider())
		else:
			return true
	
	return false
	
	
func get_end_point() -> Vector3:
	if is_colliding():
		return get_collision_point()
	else:
		return global_position + (global_basis * target_position)
		
		
# Private Functions
func _cast_for_collision() -> bool:
	force_raycast_update()
	return is_colliding()
