@icon("res://spawned_fx/spawned_fx_3d_icon.svg")
class_name SpawnedFX3D
extends Node3D


# S P A W N E D   F X
# ===================
# A simple, flexible means of spawning 3D Effects
# Handles GPUParticles3D, Lights and AudioStreamPlayer3Ds
# Not optimal for highly frequent spawning, but great to use until you know you need something specifically performant


# Export Members
@export var _light_duration := 0.2
@export var _light_curve : Curve


# Private Members
var _light : Light3D
var _light_energy := 1.0
var _lifetime := 0.0


# Default Callbacks
func _ready() -> void:
	var duration := 0.0
	for child in get_children():
		if child is GPUParticles3D:
			var fx := (child as GPUParticles3D)
			fx.emitting = true
			fx.one_shot = true
			duration = max(duration, fx.lifetime)
		elif child is Light3D:
			_light = child as Light3D
			_light_energy = _light.light_energy
			duration = max(duration, _light_duration)
		elif child is AudioStreamPlayer3D:
			var audio := child as AudioStreamPlayer3D
			audio.play()
			duration = max(duration, audio.stream.get_length())
	
	await get_tree().create_timer(duration, false, false, false).timeout		
	
	queue_free()
	
	
func _process(delta: float) -> void:
	# update light flash, if it exists
	if _light and _light_curve:
		_lifetime += delta
		var strength := _light_curve.sample(_lifetime / _light_duration)
		_light.light_energy = _light_energy * strength
		
		
# Static Functions
static func spawn(scene: PackedScene, parent: Node, point: Vector3) -> SpawnedFX3D:
	var fx := scene.instantiate() as SpawnedFX3D
	if not fx is SpawnedFX3D:
		return null
		
	parent.add_child(fx)
	fx.global_position = point
	return fx


static func spawn_aimed(scene: PackedScene, parent: Node, point: Vector3, forward: Vector3, up := Vector3.UP) -> SpawnedFX3D:
	var fx := spawn(scene, parent, point) as SpawnedFX3D
	if not fx:
		return null
	
	# prevent an identical up vector and look vector when spawning on floors or ceilings
	if forward.is_equal_approx(Vector3.UP) or forward.is_equal_approx(-Vector3.UP):
		up = Vector3.FORWARD
			
	fx.look_at(point + forward, up)
	return fx
