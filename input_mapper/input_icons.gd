class_name InputIcons
extends Resource


@export var _blank : Texture2D
@export var _buttons : Array[Texture2D]
@export var _axes : Array[Texture2D]


func get_button_icon(id: int) -> Texture2D:
	if id > -1 and id < _buttons.size() and _buttons[id]:
		return _buttons[id]
	return _blank
	

func get_axis_icon(id: int) -> Texture2D:
	if id > -1 and id < _axes.size() and _axes[id]:
		return _axes[id]
	return _blank
