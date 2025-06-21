@tool
class_name ToolLines
extends MeshInstance3D


# Signals
# Enums
# Constants
# Members
var _mesh := ArrayMesh.new()
var _lines := []


# Default Callbacks
func _enter_tree() -> void:
	# create array mesh and material
	mesh = _mesh
	material_override = StandardMaterial3D.new()
	material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_override.vertex_color_use_as_albedo = true
	material_override.disable_receive_shadows = true
	
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	child_entered_tree.connect(func(node: Node) -> void: rebuild_mesh())
	child_order_changed.connect(func(node: Node) -> void: rebuild_mesh())
	
	
# Public Functions
func add_line(start: Vector3, end: Vector3, color: Color) -> void:
	_lines.push_back( { "start": start, "end": end, "color": color } )
	
	
func rebuild_mesh() -> void:
	_mesh.clear_surfaces()
	
	# TEMP
	#if get_child_count() > 1:
		#for i in get_child_count() - 1:
			#var child := get_child(i) as Node3D
			#var next := get_child(i+1) as Node3D
			#add_line(child.global_position, next.global_position, Color.RED)
	
	if _lines.is_empty():
		return
	
	var array_data := []
	array_data.resize(Mesh.ARRAY_MAX)
	var vertices := PackedVector3Array()
	var colors := PackedColorArray()
	
	# convert all lines to mesh data
	for line : Dictionary in _lines:
		vertices.push_back(line["start"] - global_position)
		vertices.push_back(line["end"] - global_position)
		colors.push_back(line["color"])
		colors.push_back(line["color"])
		
	# build the mesh from the data
	array_data[Mesh.ARRAY_VERTEX] = vertices
	array_data[Mesh.ARRAY_COLOR] = colors
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, array_data)
	_lines.clear()


# Private Functions
