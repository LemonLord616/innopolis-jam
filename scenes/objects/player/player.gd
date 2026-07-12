extends CharacterBody3D
class_name Player


@export_category("Resources")
@export var inventory: PlayerInventoryResource

@export_category("Internal Nodes")
@export var selector: PlayerInventorySelectorComponent
@export var health: PlayerHealthComponent
@export var dash_cooldown_timer: Timer

@export_category("Controller")
@export var player_id := 0
@export var device_id := 0
@export_range(0.0001, 0.1, 0.0001) var vertical_sensitivity: float = 0.005
@export_range(0.0001, 0.1, 0.0001) var horizontal_sensitivity: float = 0.005
@export_range(0.0, 10.0, 0.1) var left_stick_dead_zone := 0.0
@export_range(0.0, 10.0, 0.1) var right_stick_dead_zone := 0.0

@export_category("Effects")
@export var disable_jump := false
@export var disable_dash := false
@export var disable_move := false
@export var disable_move_camera := false
@export var disable_change_slot := false
@export var immortal := false

@export_category("Batte")
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
## Time while dash comes to regular move spee
@export_range(0.0, 5.0, 0.1) var dash_duration := 0.5
@export var dash_fadeout_curve: Curve
## 1 means double jump, 2 is triple, 0 is jump only from ground
@export var jumps_in_air := 1
@export_range(0.0, 10.0, 0.1) var gravity_multiplier := 5.0

# signals
signal hp_changed(Player)
# signal speed_changed(Player)
# signal jump_speed_changed(Player)
# signal dash_speed_changed(Player)
# signal dashed(Player)
# signal dash_recovered(Player)
# signal disabled_jump(Player)
# signal disabled_dash(Player)
# signal disabled_move(Player)
# signal disabled_move_camera(Player)
# signal disabled_change_slot(Player)
signal selected_slot_changed(Player)

# states
var on_ground := false
var in_air := false
var move := false
var dash_active := false


func _physics_process(delta: float) -> void:
	# Logging.debug(self, velocity)
	velocity += gravity_multiplier * get_gravity() * delta
	move_and_slide()
	# Logging.debug(self, global_position)
