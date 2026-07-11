@abstract
extends Resource
class_name PlayerControllerDeviceSpecific


var player: Player
var controller: PlayerController

@abstract
func setup_controls() -> void

@abstract
func input(event: InputEvent) -> void

@abstract
func input_vector() -> Vector2

@abstract
func camera_delta() -> Vector2
