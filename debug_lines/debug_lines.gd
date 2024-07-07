class_name DebugLines
extends MeshInstance3D


# Inner Class
class Line:
	extends RefCounted
	var _start : Vector3
	var _end : Vector3
	var _color : Color
	var _life : float 
	
	func _init(start: Vector3, end: Vector3, color: Color, life: float) -> void:
		_start = start
		_end = end
		_color = color
		_life = life
		

# Private Members
var _mesh := ArrayMesh.new()
var _vertices := PackedVector3Array()
var _colors := PackedColorArray()
var _array_data := []

var _delayed_lines : Array[Line]

var _dirty := false


# Default Callbacks
func _ready() -> void:
	# create array mesh and material
	mesh = _mesh
	material_override = StandardMaterial3D.new()
	material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_override.vertex_color_use_as_albedo = true
	material_override.disable_receive_shadows = true
	
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# set array data size
	_array_data.resize(Mesh.ARRAY_MAX)
	
	# process later than default (0), to ensure all calls to this class have already been made
	process_priority = 20
	

func _process(delta: float) -> void:
	# clear the mesh
	_mesh.clear_surfaces()
	
	if _dirty:
		# add delayed lines into the list for this frame
		for line in _delayed_lines:
			_vertices.push_back(line._start)
			_vertices.push_back(line._end)
			_colors.push_back(line._color)
			_colors.push_back(line._color)
			
		# create mesh surface from all array data
		if not _vertices.is_empty():
			_array_data[Mesh.ARRAY_VERTEX] = _vertices
			_array_data[Mesh.ARRAY_COLOR] = _colors
			_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, _array_data)
			_vertices.clear()
			_colors.clear()
			
		_dirty = false
	
	# update life on all delayed lines
	for i in range(_delayed_lines.size() - 1, -1, -1):
		var line := _delayed_lines[i] as Line
		line._life -= delta
		if line._life <= 0.0:
			_delayed_lines.remove_at(i)
			_dirty = true
			
		
# Public Functions		
func draw_line(start: Vector3, end: Vector3, color: Color, duration := 0.0) -> void:
	# store line if it's wanted for more than one frame
	if duration > 0.0:
		_delayed_lines.push_back(Line.new(start, end, color, duration))
		return
	
	# add the line data to list for the next frame	
	_vertices.push_back(start)
	_vertices.push_back(end)
	_colors.push_back(color)
	_colors.push_back(color)
	
	_dirty = true
	
	
func draw_ray(origin: Vector3, ray: Vector3, color: Color, duration := 0.0) -> void:
	draw_line(origin, origin + ray, color, duration)
	
	
func draw_point(origin: Vector3, radius: float, color: Color, duration := 0.0) -> void:
	draw_line(origin - (Vector3.UP * radius), origin + (Vector3.UP * radius), color, duration)
	draw_line(origin - (Vector3.RIGHT * radius), origin + (Vector3.RIGHT * radius), color, duration)
	draw_line(origin - (Vector3.FORWARD * radius), origin + (Vector3.FORWARD * radius), color, duration)
