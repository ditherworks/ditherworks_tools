@tool
extends EditorPlugin


# Constants

# Members
var _fx_button : Button

var _held_keys := {}


# Default Callbacks
func _enter_tree() -> void:
	_enable_fx_button()
	
	scene_changed.connect(_on_scene_changed)
			
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
		if not _held_keys[KEY_P]:
			var node_3d_editor := EditorInterface.get_editor_main_screen().find_child("*Node3DEditor*", false, false)
			if not node_3d_editor or not (node_3d_editor as Control).visible:
				return
			_restart_fx()
			_held_keys[KEY_P] = true
	else:
		_held_keys[KEY_P] = false
			

func _exit_tree() -> void:
	_enable_fx_button(false)
	
	scene_changed.disconnect(_on_scene_changed)
		
		
# Private Functions		
func _enable_fx_button(enable := true) -> void:
	if enable:
		_fx_button = Button.new()
		_fx_button.text = "Preview All FX"
		_fx_button.flat = true
		_fx_button.pressed.connect(_restart_fx)
		add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _fx_button)
	else:
		remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU, _fx_button)
		_fx_button.queue_free()
		
		
func _restart_fx() -> void:
	var selection := EditorInterface.get_selection()
	var nodes := selection.get_selected_nodes()
	
	# get all selected fx
	var selected_fx : Array[GPUParticles3D]
	for node in nodes:
		if node is GPUParticles3D:
			selected_fx.push_back(node)
			
	var parents : Array[Node]
	for fx in selected_fx:
		if not parents.has(fx.get_parent()):
			parents.push_back(fx.get_parent())
				
	for parent in parents:
		for child in parent.get_children():
			if child is GPUParticles3D:
				(child as GPUParticles3D).restart()
	

func _on_scene_changed(scene_root: Node) -> void:
	# bring the scene tree dock to the front
	var scene_dock = EditorInterface.get_base_control().find_children("*", "SceneTreeDock", true, false)[0]
	scene_dock.show()
	
	# activate the appropriate editor
	var root := EditorInterface.get_edited_scene_root()
	EditorInterface.set_main_screen_editor("3D" if root is Node3D else "2D")
