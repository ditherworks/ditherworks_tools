class_name HurtBox
extends Area3D


#  Members
var _life := -1.0
var _damage := 100.0
var _creator : Node3D
var _recipients := []


# Default Callbacks	
func _ready() -> void:
	monitoring = false
	monitorable = false
	deactivate()
	
	
func _physics_process(delta: float) -> void:
	# update life
	if _life > 0.0:
		_life -= delta
		if _life <= 0.0:
			deactivate()
	
	if not monitoring:
		return
		
	#var health_overlaps : Array[Health]
	
	for area in get_overlapping_areas():
		# check it's a hitbox
		var hitbox := area as HitBox
		if not hitbox:
			continue
			
		#var health := hitbox.queue_damage(_damage)
		#if health and not health_overlaps.has(health):
			#health_overlaps.push_back(health)
			
		# check if they're new to us
		if hitbox._health and not _recipients.has(hitbox._health):
			# apply the damage
			hitbox.hurt(_damage, global_position, global_position - area.global_position, _creator)
			_recipients.append(hitbox._health)


# Public Functions
func activate(damage: float, duration: float, creator: Node3D) -> void:
	var collision := get_child(0) as CollisionShape3D
	if collision:
		collision.disabled = false 
		
	_damage = damage
	_life = duration
	_creator = creator
	_recipients.clear()
	monitoring = true
	
	set_physics_process(true)


func deactivate() -> void:
	var collision := get_child(0) as CollisionShape3D
	if collision:
		collision.disabled = true 
		
	monitoring = false
	set_physics_process(false)
