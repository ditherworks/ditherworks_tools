@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var interface := EditorInterface
	var paths := interface.get_selected_paths()
	
	for path in paths:
		prints("loading resource for mesh extraction... ", path)
		var res := ResourceLoader.load(path)
		print(res.resource_name)
	
	#var path := interface.get_current_path()
	#print(path)
	#var file_system := interface.get_resource_filesystem()
	#var file := file_system.get_filesystem_path(path)
