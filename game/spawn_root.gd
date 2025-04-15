class_name SpawnRoot
extends Node3D


# Signals
# Enums
# Constants
const DEFAULT_NAME := "Generic"


# Members
static var _instance : SpawnRoot


# Default Callbacks
# Public Functions
static func parent_to_collection(node: Node3D, collection_name := DEFAULT_NAME) -> void:
	var collection := get_collection(collection_name)

	if node.get_parent():
		node.reparent(collection)
	else:
		collection.add_child(node)
			
	
static func clear_collection(collection_name := DEFAULT_NAME) -> void:
	var collection := get_collection(collection_name)
	if collection:
		for child in collection.get_children():
			child.queue_free()


static func get_collection(collection_name := DEFAULT_NAME) -> Node3D:
	var instance := _get_instance()
	
	# return existing collection root node
	for child in instance.get_children():
		if child.name == collection_name:
			return child
			
	# create and return new collection root node
	var collection := Node3D.new()
	instance.add_child(collection)
	collection.name = collection_name
	return collection


# Private Functions
static func _get_instance() -> SpawnRoot:
	# ensure we have a single instance and pass it back
	if not _instance:
		_instance = SpawnRoot.new()
		_instance.name = "RootSpawns"
		(Engine.get_main_loop() as SceneTree).root.add_child(_instance)
		
	return _instance		
	

	
