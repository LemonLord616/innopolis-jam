extends RotationComponent
class_name Head

@export var disabled := false

@export var player: Player
@export var controller: PlayerController

func _ready() -> void:
	if disabled:
		set_process(false)
		set_physics_process(false)

func _process(delta: float) -> void:
	if player.effects.disable_move_camera:
		return
	var camera_delta = controller.camera_delta()
	if !camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotate_y(-input_delta.x * player.horizontal_sensitivity)
	rotate_x(-input_delta.y * player.vertical_sensitivity)
	rotation.x = clamp(rotation.x, deg_to_rad(-90) ,deg_to_rad(90))

func set_item(item: ItemManager.Item) -> void:
	pass
