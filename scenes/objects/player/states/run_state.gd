extends InterruptiveState
class_name PlayerRunState


@export var player: Player
@export var controller: PlayerController
@export var move_cmp: PlayerMoveComponent
@export var move_state: PlayerMoveState

signal gonna_run(state: InterruptiveState)

var _move_vector := Vector3.ZERO

func enter() -> void:
	controller.run.connect(_on_controller_run)
func exit() -> void:
	controller.run.disconnect(_on_controller_run)

func _on_controller_run(flag: bool) -> void:
	if !flag:
		switch_to_state.emit(self, move_state)

func _physics_process(_delta: float) -> void: 
	var input_vector := controller.input_vector() # xy plane
	if input_vector.is_zero_approx():
		return
	_interrupted = false
	gonna_run.emit(self)
	if !_interrupted:
		_move_vector = Vector3(input_vector.x, 0, input_vector.y) # xz plane
		move_cmp.apply_move(_move_vector, player.run_power, player.run_max_force)
