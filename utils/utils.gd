class_name Utils
extends Object


# ensure trigger buttons input events don't repeatedly fire with each travel, only when crossing threshold
static func action_just_pressed(event: InputEvent, action: String) -> bool:
	if event is InputEventJoypadMotion:
		return Input.is_action_just_pressed(action)
	return event.is_action_pressed(action)


# rescale stick input so deadzone threshold is zero
static func stick_deadzone_adjust(input: Vector2, deadzone := 0.18) -> Vector2:
	if input.length() > deadzone:
		var adjusted := inverse_lerp(deadzone, 1.0, input.length()) as float
		return input.normalized() * adjusted
	else:
		return Vector2.ZERO
		
		
# rescale single axis input so deadzone threshold is zero	
static func axis_deadzone_adjust(input: float, deadzone := 0.18) -> float:
	if input <= deadzone and input >= -deadzone:
		return 0.0
	return clampf(input, -1.0, 1.0)
