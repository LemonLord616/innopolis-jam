extends Component
class_name StunComponent


@export var move_state: PlayerMoveState


func _ready() -> void:
	move_state.gonna_move.connect(_on_gonna_move)


func _on_gonna_move(state: InterruptiveState) -> void:
	state.interrupt()
