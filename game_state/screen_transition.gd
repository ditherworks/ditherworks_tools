class_name ScreenTransition
extends Node


# Signals
signal hide_complete
signal reveal_complete


# Enums
# Constants
const DEFAULT_DURATION := 0.3


# Export Members
# Private Members
# Default Callbacks
# Public Functions
func hide(duration := -1.0) -> void:
	#if duration < 0.0:
		#duration = DEFAULT_DURATION
		#
	#await get_tree().create_timer(duration).timeout
	#
	#hide_complete.emit()
	pass

	
func reveal(duration := -1.0) -> void:
	#if duration < 0.0:
		#duration = DEFAULT_DURATION
		#
	#await get_tree().create_timer(duration).timeout
	#
	#reveal_complete.emit()
	pass
	

# Private Functions
# Signal Functions


