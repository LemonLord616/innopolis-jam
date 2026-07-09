extends InterruptiveState
class_name PlayerOnGroundState


@export var player: Player
@export var controller: PlayerController
@export var air_state: PlayerInAirState
@export var floor_cast: ShapeCast3D
@export var debug_cast: RayCast3D

signal gonna_jump(state: InterruptiveState)

func enter() -> void:
	controller.jump.connect(_on_controller_jump)
func exit() -> void:
	controller.jump.disconnect(_on_controller_jump)

func _physics_process(_delta: float) -> void:
	if !floor_cast.is_colliding():
		switch_to_state.emit(self, air_state)
		return

	# var vel = player.linear_velocity
	# var hvel = Vector3(vel.x, 0, vel.z)
	# player.apply_force(-hvel * player.damp)
	var vel = player.linear_velocity
	if vel.is_zero_approx():
		return
	var dir = Vector3(vel.x, 0, vel.z).normalized()
	var force = (-dir * player.floor_friction * player.mass *
	player.get_gravity().length())
	player.apply_force(force)
	# debug_cast.target_position = force


func _on_controller_jump() -> void:
	_interrupted = false
	gonna_jump.emit(self)
	if _interrupted:
		return
	var jump_impulse := Vector3.UP * player.jump_impulse
	Logging.debug(self, "player jumped")
	player.apply_impulse(jump_impulse)
