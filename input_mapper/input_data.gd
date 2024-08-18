class_name InputData
extends Resource


@export var _mappings := {}

var _save_list : Array


# Public Functions
func save(save_list: Array, path: String, ) -> void:
	_save_list = save_list
	
	var all_actions := InputMap.get_actions()
	
	for action in all_actions:
		# check if it's an action we wish to save
		if not _save_list.has(action):
			continue
		
		# store the events in our dictionary
		_mappings[action] = InputMap.action_get_events(action)

	if ResourceSaver.save(self, path) != OK:
		printerr("failed to save InputData")
		
		
func apply() -> void:
	print(_mappings)
	for action in _mappings:
		InputMap.action_erase_events(action)
		for event in _mappings[action]:
			InputMap.action_add_event(action, event)
	
