@icon("fx_3d_icon.svg")
class_name Fx3d
extends Node3D


# Export Members
@export var _light_duration := 0.2


# Private Members
var _light : Light3D
var _light_decay : float


# Default Callbacks
func _ready() -> void:
	var duration := 0.1
	
	for child in get_children():
		if child is GPUParticles3D:
			var fx := (child as GPUParticles3D)
			fx.emitting = true
			fx.one_shot = true
			duration = max(duration, fx.lifetime)
		elif child is Light3D:
			_light = child as Light3D
			_light_decay = (_light.light_energy / _light_duration)
			duration = max(duration, _light_duration)
		elif child is AudioStreamPlayer3D:
			var audio := child as AudioStreamPlayer3D
			audio.play()
			duration = max(duration, audio.stream.get_length())
		
	await get_tree().create_timer(duration, false, false, false).timeout
	
	queue_free()
	
	
func _process(delta: float) -> void:
	# update light flash, if it exists
	if _light:
		_light.light_energy = clampf(_light.light_energy - (_light_decay * delta), 0.0, 1.0)
		
		
# Private Functions
		
		
	
