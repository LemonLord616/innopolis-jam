extends PlayerController
class_name PlayerGpController


func _setup_controls() -> void:
	InputManager.setup_player_actions(player_id, "gp")
	InputManager.bind_player_actions_to_device(player_id, device_id)

func input_vector() -> Vector2:
	var stick_vec := InputManager.get_gamepad_left_stick(device_id)
	if stick_vec.length() < player.left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec

func camera_delta() -> Vector2:
	var stick_vec := InputManager.get_gamepad_right_stick(device_id)
	if stick_vec.length() < player.left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec
