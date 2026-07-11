extends Component
class_name StunComponent


@export var move_state: PlayerMoveState
@export var active := false

func _on_active_change(value: bool) -> void:
	if active == value:
		return
	active = value
	if active:
		move_state.gonna_move.connect(_on_gonna_move)
	else:
		move_state.gonna_move.disconnect(_on_gonna_move)


func _on_gonna_move(state: InterruptiveState) -> void:
	state.interrupt()
