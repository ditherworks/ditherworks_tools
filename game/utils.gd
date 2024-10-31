class_name Utils
extends Object


# ensure trigger buttons input events don't repeatedly fire with each travel, only when crossing threshold
static func action_just_pressed(event: InputEvent, action: String) -> bool:
	if event is InputEventJoypadMotion:
		return Input.is_action_just_pressed(action)
	return event.is_action_pressed(action)


# rescale stick input so deadzone threshold is zero
static func deadzone_adjust_float(value: float, deadzone := 0.18) -> float:
	if value > deadzone:
		return inverse_lerp(deadzone, 1.0, value)
	if value < -deadzone:
		return -inverse_lerp(-deadzone, -1.0, value)

	return 0.0
	
	
static func deadzone_adjust_vec2(input: Vector2, deadzone := 0.18) -> Vector2:
	if input.length() > deadzone:
		var adjusted := inverse_lerp(deadzone, 1.0, input.length()) as float
		return input.normalized() * adjusted
	else:
		return Vector2.ZERO
		
		
static func deadzone_adjust_vec3(input: Vector3, deadzone := 0.18) -> Vector3:
	input.limit_length()
	if input.length() > deadzone:
		var adjusted := inverse_lerp(deadzone, 1.0, input.length()) as float
		return input.normalized() * adjusted
	else:
		return Vector3.ZERO


static func get_unique_timestamp() -> String:
	var time := Time.get_time_dict_from_system()
	var seconds := int(time["hour"]) * 60 * 60
	seconds += int(time["minute"]) * 60
	seconds += int(time["second"])
	return Time.get_date_string_from_system().replace("-", ".") + "_" + str(seconds)
	
