extends Node
class_name PlayerController

@export var player: Player
@export var device_specific: DeviceSpecific # : set = _on_device_specific_change
func _on_device_specific_change(res: DeviceSpecific) -> void:
	device_specific = res
	_setup_device.call_deferred()


signal hotbar(slot: int)
signal dash
signal jump

@onready var prefix := "p" + str(player.player_id) + "_"

func _ready() -> void:
	_setup_device()

func _setup_device() -> void:
	device_specific.player = player
	device_specific.controller = self
	device_specific.setup_controls()

func _input(event: InputEvent) -> void:
	# Logging.debug(self, "input event")
	if event.is_action_pressed(prefix + "dash"):
		Logging.debug(self, "dash pressed")
		dash.emit()
	if event.is_action_pressed(prefix + "jump"):
		Logging.debug(self, "jump pressed")
		jump.emit()
	for i in range(player.inventory.slots.size()):
		if event.is_action_pressed(prefix + "hotbar_" + str(i)):
			hotbar.emit(i)
	device_specific.input(event)

func input_vector() -> Vector2:
	return device_specific.input_vector()

func camera_delta() -> Vector2:
	return device_specific.camera_delta()
