class_name UserFolder
extends Node


# U S E R   F O L D E R
# =====================
# A static class that abstracts away a folder for holding all user files (config, gamesaves etc)
# File contents is initially defined by a dictionary of default data
# It will load from existing files, ensure all default values are in and prune old, invalid ones
# Data is stored in memory for reading and writing before saving/syncing the file


# Signals
# Enums
# Constants
const DEFAULT_SECTION := "data"


# Members
static var _loaded_files := {}


# Default Callbacks
	
# Public Functions
static func load_file(local_path: String, defaults: Dictionary) -> void:
	var file_path := _get_full_valid_path(local_path)
	
	# check if we've already loaded this file
	if _loaded_files.has(local_path):
		return
		
	var file := UserFile.new()
	file.load_with_defaults(file_path, defaults)
	_loaded_files[local_path] = file
	
	
static func save_file(local_path: String) -> void:
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		file.save(_get_full_valid_path(local_path))
		_loaded_files.erase(local_path)
		

static func save_changed_files() -> void:
	for local_path : String in _loaded_files:
		var file := _loaded_files[local_path] as UserFile
		file.save_if_changed(_get_full_valid_path(local_path))
			
	
static func set_value(local_path: String, key: String, value: Variant) -> void:
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		file.set_value(DEFAULT_SECTION, key, value)
		file.mark_as_changed()
	
	
static func get_value(local_path: String, key: String) -> Variant:
	if _loaded_files.has(local_path):
		var file := _loaded_files[local_path] as UserFile
		return file.get_value(DEFAULT_SECTION, key)
		
	return null


# Private Functions
static func _get_storage_root_path() -> String:
	# get storage path based on OS
	var storage := ""
	if OS.has_feature("windows"):
		storage = OS.get_environment("APPDATA")
	if OS.has_feature("linux"):
		#! needs testing
		storage = OS.get_environment("XDG_DATA_HOME")	# ~/.local/share/ OR $XDG_DATA_HOME
	
	var project_name : String = ProjectSettings.get_setting("application/config/name")
	var path := storage.path_join(project_name)
	
	#.. add a sub folder for the user id (if on steam for example)
	#if is_steam:
		#path = path.path_join(get_steam_user_id)
		
	return path


static func _get_full_valid_path(local_path: String) -> String:
	var path := _get_storage_root_path()
	path = path.path_join(local_path)
	path = path.replace("\\", "/")
	
	# ensure saves folder exists
	var directory := path.left(path.rfind("/"))
	if not DirAccess.dir_exists_absolute(directory):
		DirAccess.make_dir_recursive_absolute(directory)
	
	return path
