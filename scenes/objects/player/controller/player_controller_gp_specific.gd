extends PlayerControllerDeviceSpecific
class_name PlayerControllerGpSpecific


func setup_controls() -> void:
	InputManager.setup_player_actions(player.player_id, "gp")
	InputManager.bind_player_actions_to_device(player.player_id, player.device_id)

func input(_event: InputEvent) -> void:
	pass

func input_vector() -> Vector2:
	var stick_vec := InputManager.get_gamepad_left_stick(player.device_id)
	if stick_vec.length() < player.left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec

func camera_delta() -> Vector2:
	var stick_vec := InputManager.get_gamepad_right_stick(player.device_id)
	if stick_vec.length() < player.left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec
