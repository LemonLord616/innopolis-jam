extends PlayerController
class_name PlayerGpController


@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

func _setup_controls() -> void:
	InputManager.setup_player_actions(player_id, "gp")
	InputManager.bind_player_actions_to_device(player_id, device_id)

func _get_input_vector() -> Vector2:
	var stick_vec := InputManager.get_gamepad_left_stick(device_id)
	if stick_vec.length() < left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec

func camera_delta() -> Vector2:
	var stick_vec := InputManager.get_gamepad_right_stick(device_id)
	if stick_vec.length() < left_stick_dead_zone:
		return Vector2.ZERO
	return stick_vec
