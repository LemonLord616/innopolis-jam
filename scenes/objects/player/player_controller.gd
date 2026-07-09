@abstract
extends Node
class_name PlayerController

signal player_move_direction(vector2d: Vector2, vector3d: Vector3)

@export var player: Player
@export var rotation_cmp: RotaitonComponent
@export var debug_raycast: RayCast3D

@onready var player_id := player.player_id
@onready var device_id := player.device_id
@onready var prefix := "p" + str(player_id) + "_"

var can_run := true
## meant to disable run if stamina zeroed until press run again
var run_button_fresh := true

func _ready() -> void:
	_setup_controls()

@abstract
func _setup_controls() -> void

@abstract
func _get_input_vector() -> Vector2

@abstract
func camera_delta() -> Vector2

func _input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void: 
	var input_vector := _get_input_vector() # xy plane
	var move_vector := Vector3(input_vector.x, 0, input_vector.y) # xz plane

	if !move_vector.is_zero_approx():
		player_move_direction.emit(input_vector, move_vector)
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
