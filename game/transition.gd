class_name Transition
extends Control


# Signals
signal out_complete()
signal in_complete()


# Enums
# Constants
# Members
# Default Callbacks
func _enter_tree() -> void:
	visible = false
	set_process_input(false)
	
	
# Public Functions
func transition_out() -> void:
	pass
	
	
func transition_in() -> void:
	pass
	
# Private Functions
