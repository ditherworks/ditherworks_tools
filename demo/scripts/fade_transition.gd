class_name FadeTransition
extends Transition


# Signals
# Enums
# Constants
const DURATION : = 0.3


# Members
@export var _color_rect: ColorRect


# Default Callbacks
# Public Functions
func transition_out() -> void:
	visible = true
	modulate = Color.TRANSPARENT
	
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, DURATION)
	
	await tween.finished
	
	out_complete.emit()
	
	
func transition_in() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, DURATION)
	
	await tween.finished
	
	visible = false
	in_complete.emit()
	
	
# Private Functions
