class_name HurtBox
extends Area3D


# Signals
signal damage_dealt(info: HurtInfoBase)


#  Members
var _hurt_info : HurtInfoBase
var _life := -1.0
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
func activate(hurt_info: HurtInfoBase, duration: float) -> void:
	_hurt_info = hurt_info
	_life = duration
	
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
			if hitbox._health.owner == _hurt_info.creator:
				continue
			hitboxes.push_back(hitbox)
	
	return hitboxes
	

func _process_overlaps() -> void:
	var affected_health := _get_all_health_overlaps(_get_all_valid_hitboxes())
		
	# hand the damage over to each health node
	for health : Health in affected_health:
		_hurt_info.point = global_position
		var result := health.overlap_hurt(_hurt_info, affected_health[health], self)
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
