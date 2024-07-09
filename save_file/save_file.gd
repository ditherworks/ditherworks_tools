class_name SaveFile
extends ConfigFile


# Constants

# Private Members

# Default Callbacks

# Public Functions
func ensure_default_values(defaults: Dictionary, remove_invalid := false) -> void:
	for section in defaults:
		for key in defaults[section]:
			if not has_section_key(section, key):
				set_value(section, key, defaults[section][key])
				
	if remove_invalid:
		remove_invalid_values(defaults)
				
				
func remove_invalid_values(valid: Dictionary) -> void:
	for section in get_sections():
		if valid.has(section):
			for key in get_section_keys(section):
				if not valid[section].has(key):
					erase_section_key(section, key)
		else:
			erase_section(section)
				

func print() -> void:
	for section in get_sections():
		print(section)
		for key in get_section_keys(section):
			prints(" ", key)
