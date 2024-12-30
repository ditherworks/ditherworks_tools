class_name HurtBox
extends Area3D


# Signals
signal damage_dealt(info: HurtInfoBase)


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
	if monitoring:
		_process_overlaps()
		_update_life(delta)


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
func _get_all_health_overlaps(hitboxes : Array[HitBox]) -> Dictionary:
	var overlaps : Dictionary
	for hitbox in hitboxes:
		if not overlaps.has(hitbox._health):
			# create new health entry with array of hitboxes
			overlaps[hitbox._health] = []
			
		# add hitbox to existing list for associated health
		var boxes : Array = overlaps[hitbox._health]
		boxes.push_back(hitbox)
		
	return overlaps
	
	
func _get_all_valid_hitboxes() -> Array[HitBox]:
	var hitboxes : Array[HitBox]
	for area in get_overlapping_areas():
		var hitbox := area as HitBox
		if hitbox and hitbox._health and not _recipients.has(hitbox._health):
			if hitbox._health.owner == _creator:
				continue
			hitboxes.push_back(hitbox)
	
	return hitboxes
	

func _process_overlaps() -> void:
	var affected_health := _get_all_health_overlaps(_get_all_valid_hitboxes())
		
	# hand the damage over to each health node
	for health : Health in affected_health:
		var info := HurtInfoBase.new(_damage, global_position, null, _creator)
		var result := health.overlap_hurt(info, affected_health[health], self)
		if result:
			damage_dealt.emit(result)
	
	# remember who we've already overlapped
	for key : Health in affected_health:
		if not _recipients.has(key):
			_recipients.push_back(key)
	
				
func _update_life(delta: float) -> void:
	if _life > 0.0:
		_life -= delta
		if _life <= 0.0:
			deactivate()
