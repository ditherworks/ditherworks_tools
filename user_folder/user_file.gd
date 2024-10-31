class_name UserFile
extends ConfigFile


# Constants
# Private Members
var _changed := false


# Default Callbacks


# Public Functions
func load_with_defaults(path: String, defaults: Dictionary, remove_invalid := true) -> void:
	self.load(path)
	
	_add_defaults(defaults)
	
	if remove_invalid:
		_remove_invalid(defaults)
	
	
func save_if_changed(path: String) -> void:
	if _changed:
		self.save(path)
		_changed = false
	
	
func mark_as_changed() -> void:
	_changed = true

	
# Private Functions
func _add_defaults(defaults: Dictionary) -> void:
	# insert any defaults that aren't accounted for
	for key : String in defaults:
		if not has_section_key("data", key):
			set_value(UserFolder.DEFAULT_SECTION, key, defaults[key])
	
	
func _remove_invalid(defaults: Dictionary) -> void:
	# remove any entries that aren't in defaults
	for key : String in get_section_keys(UserFolder.DEFAULT_SECTION):
		if not defaults.has(key):
			erase_section_key(UserFolder.DEFAULT_SECTION, key)
