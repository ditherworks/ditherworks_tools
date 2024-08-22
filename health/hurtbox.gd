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
	if not monitoring:
		return
		
	var health_overlaps : Array[Health]
	
	for area in get_overlapping_areas():
		# ignore if not a hitbox
		var hitbox := area as HitBox
		if not hitbox:
			continue
		
		# ignore if they have not associated health
		var health := hitbox._health
		if not health:
			continue
		
		# ignore if we alreayd hurt them	
		if _recipients.has(health):
			continue
				
		if not health_overlaps.has(health):
			health_overlaps.push_back(health)
			
		hitbox.request_damage(_damage, owner)
			
	for health in health_overlaps:
		health.trigger_requested_damage()
		if not _recipients.has(health):
			_recipients.push_back(health)
			
	# update life
	if _life > 0.0:
		_life -= delta
		if _life <= 0.0:
			deactivate()


# Public Functions
func activate(damage: float, duration: float, creator: Node3D) -> void:
	_damage = damage
	_life = duration
	_creator = creator
	
	var collision := get_child(0) as CollisionShape3D
	if collision:
		collision.disabled = false 
		
	_recipients.clear()
		
	monitoring = true
	
	set_physics_process(true)


func deactivate() -> void:
	var collision := get_child(0) as CollisionShape3D
	if collision:
		collision.disabled = true 
		
	monitoring = false
	set_physics_process(false)
	
	
# Private Functions
