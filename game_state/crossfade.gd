class_name CrossFade
extends ScreenTransition


# Export Members
@export var _color_rect_path : NodePath


# Private Members
@onready var _rect := get_node(_color_rect_path) as ColorRect


# Default Callbacks
# Public Functions
func hide(duration := -1.0) -> void:
	_rect.visible = true
	
	var tween := _create_alpha_tween(0.0, 1.0, duration)
	
	await tween.finished	
	
	hide_complete.emit()

	
func reveal(duration := -1.0) -> void:
	var tween := _create_alpha_tween(1.0, 0.0, duration)
	
	await tween.finished
	
	_rect.visible = false
	
	reveal_complete.emit()
	
	
# Private Functions
func _create_alpha_tween(start_alpha: float, end_alpha: float, duration: float) -> Tween:
	if duration < 0.0:
		duration = DEFAULT_DURATION
		
	_rect.self_modulate.a = start_alpha
	
	var tween := create_tween()
	tween.tween_property(_rect, "self_modulate", Color(1.0, 1.0, 1.0, end_alpha), duration)
	
	return tween
	
	
