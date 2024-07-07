class_name HurtBox
extends Area3D


# Export Members


# Private Members
var _life := -1.0
var _damage := 100.0
var _creator : Node3D
var _recipients := []


# Default Callbacks	
func _ready() -> void:
	monitoring = false
	
	
func _physics_process(delta: float) -> void:
	# update life
	if _life > 0.0:
		_life -= delta
		if _life <= 0.0:
			deactivate()
	
	if not monitoring:
		return
		
	for area in get_overlapping_areas():
		# check it's a hitbox
		var hitbox = area as HitBox
		if not hitbox:
			continue
		
		# check if they're new to us
		if hitbox._health and _recipients.find(hitbox._health) == -1:
			# apply the damage
			hitbox.hurt(_damage, global_position, global_position - area.global_position, _creator)
			_recipients.append(hitbox._health)


# Public Functions
func activate(damage: float, duration: float, creator: Node3D) -> void:
	_damage = damage
	_life = duration
	_creator = creator
	_recipients.clear()
	monitoring = true


func deactivate() -> void:
	monitoring = false
