extends State
class_name PlayerInAirState

@export var player: Player
@export var controller: PlayerController
@export var ground_state: PlayerOnGroundState

var _jump_count := 0

func enter() -> void:
	controller.jump.connect(_on_controller_jump)
	_jump_count = 0
	player.in_air = true
func exit() -> void:
	controller.jump.disconnect(_on_controller_jump)
	player.in_air = false

func _physics_process(_delta: float) -> void:
	if player.is_on_floor():
		switch_to_state.emit(self, ground_state)

func _on_controller_jump() -> void:
	if player.effects.disable_jump:
		return
	if _jump_count >= player.jumps_in_air:
		return
	_jump_count += 1
	Logging.debug(self, "player jumped")
	player.velocity.y = player.jump_speed
