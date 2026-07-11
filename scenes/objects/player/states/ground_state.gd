extends InterruptiveState
class_name PlayerOnGroundState


@export var player: Player
@export var controller: PlayerController
@export var dash_state: PlayerDashState
@export var air_state: PlayerInAirState

signal gonna_jump(state: InterruptiveState)

func enter() -> void:
	controller.jump.connect(_on_controller_jump)
func exit() -> void:
	controller.jump.disconnect(_on_controller_jump)

func _physics_process(_delta: float) -> void:
	if !player.is_on_floor():
		switch_to_state.emit(self, air_state)

func _on_controller_jump() -> void:
	_interrupted = false
	gonna_jump.emit(self)
	if _interrupted:
		return
	Logging.debug(self, "player jumped")
	player.velocity.y = player.jump_speed
