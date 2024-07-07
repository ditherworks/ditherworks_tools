class_name GameState
extends Node


@onready var _game := get_parent() as Game


func enable(activate := true) -> void:
	if activate:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
		
		
func enter() -> void:
	pass
	

func exit() -> void:
	pass
	
