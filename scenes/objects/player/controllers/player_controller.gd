@abstract
extends Node
class_name PlayerController

@export var player: Player

signal hotbar(slot: int)
signal run(flag: bool)
signal jump

@onready var player_id := player.player_id
@onready var device_id := player.device_id
@onready var prefix := "p" + str(player_id) + "_"


func _ready() -> void:
	_setup_controls()

func _input(event: InputEvent) -> void:
	if event.is_action(prefix + "run"):
		var flag = event.is_pressed()
		Logging.debug(self, "run " + "pressed" if flag else "release")
		run.emit(flag)
	if event.is_action_pressed(prefix + "jump"):
		Logging.debug(self, "jump pressed")
		jump.emit()
	for i in range(player.hotbar_keys):
		if event.is_action_pressed(prefix + "hotbar_" + str(i)):
			hotbar.emit(i)

@abstract
func _setup_controls() -> void

@abstract
func input_vector() -> Vector2

@abstract
func camera_delta() -> Vector2
