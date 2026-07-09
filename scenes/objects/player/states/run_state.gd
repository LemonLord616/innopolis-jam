extends ReactiveState
class_name PlayerRunState


@export var player: Player
@export var controller: PlayerController
@export var rotation_cmp: PlayerRotaitonComponent
@export var debug_raycast: RayCast3D

@export var move_state: PlayerMoveState

var _move_vector := Vector3.ZERO

func enter() -> void:
	controller.run.connect(_on_controller_run)
func exit() -> void:
	controller.run.disconnect(_on_controller_run)

func _on_controller_run(flag: bool) -> void:
	if !flag:
		switch_to_state.emit(self, move_state)

func _physics_process(delta: float) -> void: 
	var input_vector := controller.input_vector() # xy plane
	if input_vector.is_zero_approx():
		return
	_move_vector = Vector3(input_vector.x, 0, input_vector.y) # xz plane
	debug_raycast.target_position = _move_vector * 10
	trigger()

func execute() -> void:
	_apply_move(_move_vector, player.run_power, player.run_max_force)

func _apply_move(move_vector: Vector3, power: float, max_force: float) -> void:
	if move_vector.is_zero_approx():
		return

	var rotated_move = move_vector.rotated(Vector3.UP, rotation_cmp.global_rotation.y)

	var velocity := player.linear_velocity
	var effective_speed = rotated_move.dot(velocity)
	
	var force_magnitude := 0.
	if is_zero_approx(effective_speed) or effective_speed < 0:
		force_magnitude = max_force
	else:
		force_magnitude = power / effective_speed
	
	var move_force = clamp(force_magnitude, 0, max_force) * rotated_move
	
	player.apply_force(move_force)
