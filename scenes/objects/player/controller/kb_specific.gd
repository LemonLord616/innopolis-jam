extends DeviceSpecific
class_name KbSpecific

var _mouse_delta := Vector2.ZERO

func setup_controls() -> void:
	InputManager.setup_player_actions(player.player_id, "kb")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func input_vector() -> Vector2:
	var prefix := controller.prefix
	return Input.get_vector(
		prefix + "move_left", prefix + "move_right", prefix + "move_up", prefix + "move_down"
	)

func input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_delta += event.relative

func camera_delta() -> Vector2:
	var result = _mouse_delta
	_mouse_delta = Vector2.ZERO
	return result
