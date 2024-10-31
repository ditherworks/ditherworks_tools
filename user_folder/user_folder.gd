class_name UserFolder
extends Node


# Signals
# Enums
# Constants
const DEFAULT_SECTION := "data"


# Members
var _loaded_files := {}


# Default Callbacks
func _ready() -> void:
	#! test process, mimicking an external class accessing this class
	var display := { "fullscreen": false, "vsync": true }
	var controls := { "fire": 1, "invert_mouse": false }
	var records := { "level": 69, "alive": true }
	
	load_file("config/display.cfg", display)
	load_file("config/controls.cfg", controls)
	load_file("saves/records.sav", records)
	
	save_file("config/display.cfg")
	save_file("config/controls.cfg")
	save_file("saves/records.sav")
	
	
# Public Functions
func load_file(local_path: String, defaults: Dictionary) -> void:
	var file_path := _get_full_valid_path(local_path)
	
	# check if we've already loaded this file
	if _loaded_files.has(local_path):
		return
		
	var file := UserFile.new()
	file.load_with_defaults(file_path, defaults)
	_loaded_files[local_path] = file
	
	
func save_file(local_path: String) -> void:
	var file_path := _get_full_valid_path(local_path)
	
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		file.save(file_path)
	
	
func set_value(local_path: String, key: String, value: Variant) -> void:
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		file.set_value(DEFAULT_SECTION, key, value)
	
	
func get_value(local_path: String, key: String) -> Variant:
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		return file.get_value(DEFAULT_SECTION, key)
		
	return null


# Private Functions
func _get_storage_root_path() -> String:
	# get storage path based on OS
	var storage := ""
	if OS.has_feature("windows"):
		storage = OS.get_environment("APPDATA")
	if OS.has_feature("linux"):
		#! needs testing
		storage = OS.get_environment("XDG_DATA_HOME")	# ~/.local/share/ OR $XDG_DATA_HOME
	
	var project_name : String = ProjectSettings.get_setting("application/config/name")
	var path := storage.path_join(project_name)
	
	#.. add a folder for the user id (if on steam for example)
	#if is_steam:
		#path = path.path_join(get_steam_user_id)
		
	return path


func _get_full_valid_path(local_path: String) -> String:
	var path := _get_storage_root_path()
	path = path.path_join(local_path)
	path = path.replace("\\", "/")
	
	# ensure saves folder exists
	var directory := path.left(path.rfind("/"))
	if not DirAccess.dir_exists_absolute(directory):
		DirAccess.make_dir_recursive_absolute(directory)
	
	return path
