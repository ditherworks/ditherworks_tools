class_name InputIcons
extends Resource


@export var _blank : Texture2D
@export var _textures : Array[Texture2D]


func get_icon(id: int) -> Texture2D:
	if id > -1 and id < _textures.size() and _textures[id]:
		return _textures[id]
	return _blank
