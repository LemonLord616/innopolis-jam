extends State

@export var player: Player
@export var ground_state: PlayerOnGroundState
@export var floor_cast: ShapeCast3D

func enter() -> void:
	pass
func exit() -> void:
	pass

func _physics_process(delta: float) -> void:
	if floor_cast.is_colliding():
		switch_to_state.emit(self, ground_state)
		return

	# var vel = player.linear_velocity
	# if vel.is_zero_approx():
	# 	return
	# player.apply_force(-vel * player.air_damp)
