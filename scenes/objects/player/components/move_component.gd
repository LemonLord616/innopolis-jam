extends Component
class_name PlayerMoveComponent


@export var player: Player
@export var controller: PlayerController
@export var rotation_cmp: PlayerRotaitonComponent
@export var debug_raycast: RayCast3D


func _physics_process(delta: float) -> void: 
	var input_vector := controller.input_vector() # xy plane
	if input_vector.is_zero_approx():
		return
	var move_vector := Vector3(input_vector.x, 0, input_vector.y) # xz plane
	debug_raycast.target_position = move_vector * 10
	_apply_move(move_vector, player.power, player.max_force)

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
