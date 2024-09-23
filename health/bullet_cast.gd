class_name BulletCast
extends RayCast3D


# Signals
# Enums
# Constants
# Members
@export var _impact_fx : PackedScene


# Default Callbacks
func _ready() -> void:
	enabled = false
	collide_with_areas = true
	
	
# Public Functions
func shoot() -> void:
	clear_exceptions()
	
	while _cast_for_collision():
		var hitbox := get_collider() as HitBox
		if hitbox:
			hitbox.hurt(10.0, get_collision_point(), get_collision_normal(), self)
			_show_impact()
			return
		
		if get_collider() is Area3D:
			add_exception(get_collider())
			prints("ignoring", get_collider())
		else:
			_show_impact()
			return
	
	var tip := global_position + (global_basis * target_position)
	g_lines.draw_line(global_position, tip, Color.ORANGE_RED, 1.0)
		
		
# Private Functions
func _cast_for_collision() -> bool:
	#force_update_transform()
	force_raycast_update()
	return is_colliding()
	

func _show_impact() -> void:
	g_lines.draw_line(global_position, get_collision_point(), Color.ORANGE_RED, 1.0)
	g_lines.draw_point(get_collision_point(), 0.1, Color.RED, 1.0)
	if _impact_fx:
		SpawnedFX3D.spawn_aimed(_impact_fx, get_tree().root, get_collision_point(), get_collision_normal())
