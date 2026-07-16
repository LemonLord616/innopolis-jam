extends CharacterBody3D
class_name Player


@export_category("Resources")
@export var inventory: PlayerInventoryResource
@export var effects: PlayerEffectsResource
@export var health: PlayerHealthResource
var current_item_res: ItemResource

@export_category("Internal Nodes")
@export var head: Head
@export var controller: PlayerController
@export var dash_cooldown_timer: Timer

@export_category("Controller")
@export var player_id := 0
@export var device_id := 0
@export_range(0.0001, 0.1, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(0.0001, 0.1, 0.0001) var horizontal_sensitivity: float = 0.005
@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

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
var item_primary_ready := false
var item_primary_using := false
var item_secondary_ready := false
var item_secondary_using := false


func _physics_process(delta: float) -> void:
	velocity += gravity_multiplier * get_gravity() * delta
	move_and_slide()


func _ready() -> void:
	health.reset.call_deferred()
