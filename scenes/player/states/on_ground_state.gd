extends State
class_name PlayerOnGroundState


@export var player: Player
@export var dash_state: PlayerDashingState
@export var air_state: PlayerInAirState


func enter() -> void:
	player.controller.jump.connect(_on_controller_jump)
	player.on_ground = true
func exit() -> void:
	player.controller.jump.disconnect(_on_controller_jump)
	player.on_ground = false

func _physics_process(_delta: float) -> void:
	if not player.is_on_floor():
		switch_to_state.emit(self, air_state)

func _on_controller_jump() -> void:
	if player.effects.disable_jump:
		return
	Logging.debug(self, "player jumped")
	player.velocity.y = player.jump_speed
