extends RigidBody3D
class_name Player


@export var player_id := 0
@export var device_id := 0

@export_range(0.0, 1000.0, 1.0, "Watt") var power := 100.0
@export_range(0.0, 1000.0, 1.0, "Newton") var max_force := 100.0
@export_range(0.0, 1000.0, 1.0, "Coefficient") var damp := 50.0
# @export_range(0.0, 1000.0, 1.0, "m/s") var speed := 100.0


func _ready() -> void:
	lock_rotation = true


func _process(delta: float) -> void:
	pass
