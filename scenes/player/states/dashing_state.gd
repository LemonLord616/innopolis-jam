extends State
class_name PlayerDashingState

@export var player: Player
@export var head: Head
@export var move_state: PlayerMovingState
@export var dash_cooldown: Timer

var knockback := false
var knockback_dir := Vector3.ZERO
var knockback_speed := 0.0
var _timer := 0.0

func enter() -> void:
	player.knockbacked.connect(dash)
	var dir := head.facing_dir()
	var speed := player.dash_speed
	if knockback:
		dir = knockback_dir
		speed = knockback_speed
	elif player.dash_direction == Player.DashDirection.MOVE:
		var input_vec := player.controller.input_vector()
		if not input_vec.is_zero_approx():
			var move_dir := Vector3(input_vec.x, 0, input_vec.y)
			dir = head.rotated_vec(move_dir)
	dash(dir, speed)
	player.dash_active = true

func dash(dir: Vector3, speed: float) -> void:
	var dash_vel := dir * speed
	player.velocity.x = dash_vel.x
	player.velocity.z = dash_vel.z
	_timer = player.dash_duration

func exit() -> void:
	player.knockbacked.disconnect(dash)
	dash_cooldown.wait_time = player.dash_cooldown_duration
	dash_cooldown.start()
	player.dash_active = false

func _physics_process(delta: float) -> void:
	if _timer <= 0.0:
		switch_to_state.emit(self, move_state)
	_timer -= delta

	if player.effects.disable_move:
		return
	var input_vec := player.controller.input_vector()
	var target := Vector3.ZERO
	if not input_vec.is_zero_approx():
		var dir := Vector3(input_vec.x, 0, input_vec.y).rotated(Vector3.UP, head.global_rotation.y)
		target = dir * player.speed
	var duration := player.dash_duration
	var t := (duration - _timer) / duration
	var blend := player.dash_fadeout_curve.sample(t)
	player.velocity.x = lerp(player.velocity.x, target.x, blend)
	player.velocity.z = lerp(player.velocity.z, target.z, blend)
