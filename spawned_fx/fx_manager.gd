class_name FxManager
extends Node3D


# Signals
# Enums
# Constants
const PARENTED_GROUP_NAME := "parented_fx"


# Members
@export var _fx_scenes : Array[PackedScene]


var _library : Dictionary


# Default Callbacks
func _ready() -> void:
	_compile_library()
	

# Public Functions
# Private Functions
func spawn(filename: StringName, point: Vector3, parent : Node3D = null) -> Fx3d:
	if not _library.has(filename):
		print(filename + " not found in fx library")
	
	var fx := _library[filename].instantiate() as Fx3d
	if not fx is Fx3d:
		return null
	
	if parent:
		parent.add_child(fx)
		fx.add_to_group(PARENTED_GROUP_NAME)
	else:
		add_child(fx)
		
	fx.global_position = point
	
	return fx


func spawn_aimed(filename: StringName, point: Vector3, forward: Vector3, up := Vector3.UP, parent : Node3D = null) -> Fx3d:
	var fx := spawn(filename, point, parent) as Fx3d
	if not fx:
		return null
	
	# prevent an identical up vector and look vector when spawning on floors or ceilings
	if forward.normalized().is_equal_approx(Vector3.UP) or forward.normalized().is_equal_approx(-Vector3.UP):
		up = Vector3.FORWARD
			
	fx.look_at(point + forward, up)
	
	return fx
	
	
func _compile_library() -> void:
	for scene : PackedScene in _fx_scenes:
		var filename := scene.resource_path.left(scene.resource_path.rfind("."))
		filename = filename.right(filename.length() - 1 - filename.rfind("/") )
		
		if not _library.has(filename):
			print("Adding fx to library..." + filename)
			_library[filename] = scene
		else:
			print("! duplicate fx filename found " + scene.resource_path)
			

func clear_all() -> void:
	# clear all fx parented to ourself
	for child in get_children():
		if child is Fx3d:
			child.hide()
			child.queue_free()
	
	# clear those attached to some other object
	if get_tree().has_group(PARENTED_GROUP_NAME):
		var attached := get_tree().get_nodes_in_group(PARENTED_GROUP_NAME)
		for fx in attached:
			fx.hide()
			fx.queue_free()
	
	
	
