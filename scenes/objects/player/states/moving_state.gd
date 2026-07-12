extends State
class_name PlayerMovingState


@export var player: Player
@export var controller: PlayerController
@export var head: Head
@export var dash_state: PlayerDashingState
@export var dash_cooldown: Timer 

func enter() -> void:
	controller.dash.connect(_on_controller_dash)
	player.move = true
func exit() -> void:
	controller.dash.disconnect(_on_controller_dash)
	player.move = false

func _physics_process(_delta: float) -> void:
	if player.effects.disable_move:
		return
	var input_vec = controller.input_vector()
	if input_vec.is_zero_approx():
		player.velocity.x = 0
		player.velocity.z = 0
		return
	var move_dir = Vector3(input_vec.x, 0, input_vec.y)
	var rotated_dir = head.rotated_vec(move_dir)
	var move_vel = rotated_dir * player.speed
	player.velocity.x = move_vel.x
	player.velocity.z = move_vel.z

func _on_controller_dash() -> void:
	if not dash_cooldown.is_stopped():
		return
	if player.effects.disable_dash:
		return
	switch_to_state.emit(self, dash_state)
