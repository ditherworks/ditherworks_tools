class_name PlayerMelee
extends PlayerState


# Signals
# Enums
# Constants
const DURATION := 0.25


# Members
@export var _idle_state : PlayerIdle
@export var _fall_state : PlayerFall

@export var _lunge_speed := 7.0
@export var _movement : Curve


# Default Callbacks
# Public Functions
func enter() -> void:
	if _player._melee_hurtbox:
		_player._melee_hurtbox.activate(10.0, DURATION, _player)
	
	
func fixed_update(delta: float, time_in_state: float) -> void:
	# perform lunge motion
	var scaling := _movement.sample(time_in_state / DURATION)
	_player.set_fixed_motion(-(_player.global_basis.z * _lunge_speed * scaling))
		
	if not _player.is_on_floor():
		change_state.emit(_fall_state)
		return
		
	if time_in_state > DURATION:
		change_state.emit(_idle_state)
		return
		
		
# Private Functions
# Signal Functions
