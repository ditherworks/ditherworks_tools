@tool
extends EditorScenePostImport


# I M P O R T   M U L T I   M O D E L
# ===================================
# Extracts multiple models from a single blender file
# It zeroes their origin and saves them out to their own scene file
# Useful for collections of props


# called after the scene is imported and gets the root node
func _post_import(scene: Node) -> Object:
	# get source file path and remove the file extension
	var source := get_source_file()
	var path := source.substr(0, source.rfind("."))
	
	for node in scene.get_children():
		# dupe node and zero it's position
		var dupe := node.duplicate() as Node3D
		dupe.position = Vector3.ZERO
				
		# update all children's owner 
		for child in dupe.get_children():
			child.owner = dupe
	
		# pack it into a scene
		var packedScene := PackedScene.new()
		packedScene.pack(dupe)
				
		# save it
		if ResourceSaver.save(packedScene, path + "_" + node.name.to_lower() + ".tscn") == OK:
			prints(node.name.to_lower(), "exported to packed scene")

	return scene
