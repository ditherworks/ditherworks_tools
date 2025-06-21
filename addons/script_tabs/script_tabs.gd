@tool
extends EditorPlugin


# Members
var _script_list : ItemList
var _tab_container : TabContainer
var _hovered_tab := -1
var _debug_element : Control


# Default Callbacks
func _enter_tree() -> void:
	_enable_script_tabs()
	
	
func _process(delta: float) -> void:
	#if _debug_element and Input.is_key_pressed(KEY_ALT):
		#if Input.is_key_pressed(KEY_MINUS):
			#_debug_element.hide()
		#if Input.is_key_pressed(KEY_EQUAL):
			#_debug_element.show()
	pass


func _exit_tree() -> void:
	_enable_script_tabs(false)


# Private Functions
func _enable_script_tabs(enable := true) -> void:
	_script_list = EditorInterface.get_script_editor().find_children("*", "ItemList", true, false)[0]
	_tab_container = EditorInterface.get_script_editor().find_children("*", "TabContainer", true, false)[0]
	var tab_bar = _tab_container.find_child("*TabBar*", true, false)
		
	if enable:
		_script_list.property_list_changed.connect(_on_script_list_updated)
		_tab_container.tabs_visible = true
		_tab_container.drag_to_rearrange_enabled = true
		tab_bar.tab_hovered.connect(_on_script_tab_hovered)
		tab_bar.gui_input.connect(_on_script_tabs_gui_event)
		
		#var vsplit := _script_list.get_parent().get_parent().get_parent()
		#_debug_element = vsplit.get_child(0)
		#print(vsplit.get_child_count())
		#print(vsplit.split_offset)
	else:
		_script_list.property_list_changed.disconnect(_on_script_list_updated)
		tab_bar.tab_hovered.disconnect(_on_script_tab_hovered)
		tab_bar.gui_input.disconnect(_on_script_tabs_gui_event)
	
	
func _update_tabs() -> void:
	for item_id in _script_list.item_count:
		_tab_container.set_tab_title(item_id, _script_list.get_item_text(item_id))
		_tab_container.set_tab_icon(item_id, _script_list.get_item_icon(item_id))
					

# Signal Functions
func _on_script_list_updated() -> void:
	_update_tabs.call_deferred()
	
	
func _on_script_tab_hovered(tab: int) -> void:
	_hovered_tab = tab
	
	
func _on_script_tabs_gui_event(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_MIDDLE:
			if _hovered_tab > -1 and _hovered_tab < _script_list.item_count:
				_script_list.item_clicked.emit(_hovered_tab, _script_list.get_local_mouse_position(), MOUSE_BUTTON_MIDDLE)
