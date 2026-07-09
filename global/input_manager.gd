extends Node
class_name InputManager


## ref_prefix - ["kb", "gp"]
static func setup_player_actions(player_id: int, ref_prefix: String) -> void:
	var prefix := "p" + str(player_id) + "_"
	for action in InputMap.get_actions():
		if action.begins_with(ref_prefix):
			var suffix = action.substr( len(prefix) )
			_copy_action_binding(action, prefix + suffix)

static func bind_player_actions_to_device(player_id: int, device_id: int) -> void:
	var prefix := "p" + str(player_id) + "_"
	for action in InputMap.get_actions():
		if action.begins_with(prefix):
			_bind_action_to_device(action, device_id)


static func _copy_action_binding(source_action, target_action) -> void:
	if not InputMap.has_action(source_action):
		return
	if not InputMap.has_action(target_action):
		InputMap.add_action(target_action)
	else:
		InputMap.action_erase_events(target_action)
	
	for event in InputMap.action_get_events(source_action):
		var new_event = event.duplicate()
		InputMap.action_add_event(target_action, new_event)

static func _bind_action_to_device(action: String, device_id: int) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:
			event.device = device_id


static func get_gamepad_left_stick(device_id: int) -> Vector2:
	return Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y)
	)

static func get_gamepad_right_stick(device_id: int) -> Vector2:
	return Vector2(
		Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(device_id, JOY_AXIS_RIGHT_Y)
	)
