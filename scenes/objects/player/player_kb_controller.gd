extends PlayerController
class_name PlayerKbController

var _mouse_delta := Vector2.ZERO

func _setup_controls() -> void:
	InputManager.setup_player_actions(player_id, "kb")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _get_input_vector() -> Vector2:
	return Input.get_vector(
		prefix + "move_left", prefix + "move_right", prefix + "move_up", prefix + "move_down"
	)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_mouse_delta += event.relative

func camera_delta() -> Vector2:
	var result = _mouse_delta
	_mouse_delta = Vector2.ZERO
	return result
