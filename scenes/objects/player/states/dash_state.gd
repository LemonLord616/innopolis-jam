extends InterruptiveState
class_name PlayerDashState

@export var player: Player
@export var controller: PlayerController
@export var rotation_cmp: PlayerRotaitonComponent
@export var move_state: PlayerMoveState
@export var dash_cooldown: Timer

var _timer: float = 0.0

func enter() -> void:
	var dir := Vector3.ZERO
	if player.dash_direction == Player.DashDirection.FACE:
		dir = rotation_cmp.facing_dir()
	else:
		var input_vec := controller.input_vector()
		var move_dir := Vector3(input_vec.x, 0, input_vec.y)
		dir = rotation_cmp.rotated_vec(move_dir)
	var dash_vel := dir * player.dash_speed
	player.velocity.x = dash_vel.x
	player.velocity.z = dash_vel.z
	_timer = player.dash_duration

func exit() -> void:
	dash_cooldown.wait_time = player.dash_cooldown
	dash_cooldown.start()

func _physics_process(delta: float) -> void:
	if _timer <= 0.0:
		switch_to_state.emit(self, move_state)
	_timer -= delta

	var input_vec := controller.input_vector()
	var target := Vector3.ZERO
	if not input_vec.is_zero_approx():
		var dir := Vector3(input_vec.x, 0, input_vec.y).rotated(Vector3.UP, rotation_cmp.global_rotation.y)
		target = dir * player.speed
	var duration := player.dash_duration
	var t := (duration - _timer) / duration
	var blend := player.dash_fadeout_curve.sample(t)
	player.velocity.x = lerp(player.velocity.x, target.x, blend)
	player.velocity.z = lerp(player.velocity.z, target.z, blend)
