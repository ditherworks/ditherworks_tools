@icon("fx_3d_icon.svg")
class_name Fx3d
extends Node3D


# Export Members
@export var _light_duration := 0.2


# Private Members
var _light : Light3D
var _light_decay : float
var _duration := 0.0


# Default Callbacks
func _ready() -> void:
	_duration = 0.1
	
	for child in get_children():
		if child is GPUParticles3D:
			var fx := (child as GPUParticles3D)
			fx.emitting = true
			fx.one_shot = true
			_duration = max(_duration, fx.lifetime)
		elif child is Light3D:
			_light = child as Light3D
			_light.show()
			_light_decay = (_light.light_energy / _light_duration)
			_duration = max(_duration, _light_duration)
		elif child is AudioStreamPlayer3D:
			var audio := child as AudioStreamPlayer3D
			audio.play()
			_duration = max(_duration, audio.stream.get_length())

	
func _process(delta: float) -> void:
	if _light:
		_light.light_energy = maxf(_light.light_energy - (_light_decay * delta), 0.0)
		
	_duration -= delta
	if _duration <= 0.0:
		queue_free()
		
		
# Private Functions
		
		
	
