extends RigidBody3D
class_name RigidPlayer


@export var player_id := 0
@export var device_id := 0

@export_range(0.0001, 0.1, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(0.0001, 0.1, 0.0001) var horizontal_sensitivity: float = 0.005

@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

@export var inventory: PlayerInventoryResource
@export var selector: PlayerInventorySelectorComponent

@export_range(0.0, 10000.0, 1.0, "Watt") var power := 1600.0
@export_range(0.0, 10000.0, 1.0, "Newton") var max_force := 1600.0
@export_range(0.0, 10000.0, 1.0, "Watt") var run_power := 6400.0
@export_range(0.0, 10000.0, 1.0, "Newton") var run_max_force := 6400.0
@export_range(0.0, 1000.0, 1.0, "Newton") var jump_impulse := 100.0

# @export_range(0.0, 100.0, 1.0, "Coefficient") var air_damp := 40.0
@export_range(0.0, 1.0, 0.1, "Coefficient") var floor_friction := 1.0
# @export_range(0.0, 1000.0, 1.0, "Coefficient") var damp := 50.0

# @export_range(0.0, 1000.0, 1.0, "m/s") var speed := 100.0


func _ready() -> void:
	lock_rotation = true

# func _physics_process(delta: float) -> void:
# 	Logging.logging_level = Logging.LoggingLevel.WARNING
# 	Logging.warning(self, str(global_position))
