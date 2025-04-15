@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	for node in scene.get_children():
		node.position = Vector3.ZERO

	return scene
