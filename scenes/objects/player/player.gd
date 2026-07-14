extends CharacterBody3D
class_name Player


@export_category("Resources")
@export var inventory: PlayerInventoryResource
@export var effects: PlayerEffectsResource

@export_category("Internal Nodes")
@export var selector: PlayerInventorySelectorComponent
@export var health: HealthComponent
@export var head: Head
@export var item_use_ready_state: PlayerItemUseReadyState
@export var item_using_state: PlayerItemUsingState
@export var dash_cooldown_timer: Timer

@export_category("Controller")
@export var player_id := 0
@export var device_id := 0
@export_range(0.0001, 0.1, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(0.0001, 0.1, 0.0001) var horizontal_sensitivity: float = 0.005
@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

@export_category("Battle")
@export_range(1.0, 1000.0, 1.0) var max_hp := 100.0

@export_category("Movement")
@export_range(0.0, 100.0, 1.0) var speed := 10.0
@export_range(0.0, 100.0, 1.0) var jump_speed := 30.0
@export_range(0.0, 100.0, 1.0) var dash_speed := 50.0
enum DashDirection {
	FACE, MOVE
}
@export var dash_direction: DashDirection
@export_range(0.0, 5.0, 0.1) var dash_cooldown_duration := 0.5
@export_range(0.0, 5.0, 0.1) var dash_duration := 0.5
@export var dash_fadeout_curve: Curve
@export var jumps_in_air := 1
@export_range(0.0, 10.0, 0.1) var gravity_multiplier := 5.0

# states
var on_ground := false
var in_air := false
var move := false
var dash_active := false


func _physics_process(delta: float) -> void:
	velocity += gravity_multiplier * get_gravity() * delta
	move_and_slide()
