extends CharacterBody3D
class_name Player

@export var player_id := 0
@export var device_id := 0

@export_range(0.0001, 0.1, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(0.0001, 0.1, 0.0001) var horizontal_sensitivity: float = 0.005

@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

@export var inventory: PlayerInventoryResource
@export var selector: PlayerInventorySelectorComponent

@export_range(0.0, 100.0, 1.0) var speed := 5.0
@export_range(0.0, 100.0, 1.0) var jump_speed := 5.0
@export_range(0.0, 100.0, 1.0) var dash_speed := 5.0
enum DashDirection {
	FACE, MOVE
}
@export var dash_direction: DashDirection
@export_range(0.0, 5.0, 0.1) var dash_cooldown := 2.0
## Time while dash comes to regular move spee
@export_range(0.0, 5.0, 0.1) var dash_duration := 1.0
@export var dash_fadeout_curve: Curve
@export_range(0.0, 10.0, 0.1) var gravity_multiplier := 1.0


func _physics_process(delta: float) -> void:
	# Logging.debug(self, velocity)
	velocity += gravity_multiplier * get_gravity() * delta
	move_and_slide()
	# Logging.debug(self, global_position)
