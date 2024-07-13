class_name BaseState
extends Node


signal change_state(next_state: BaseState)


func enter() -> void:
	pass
	
	
func fixed_update(delta: float, time_in_state: float) -> void:
	pass
	
	
func unhandled_input(event: InputEvent) -> void:
	pass
	

func exit() -> void:
	pass
	
	
