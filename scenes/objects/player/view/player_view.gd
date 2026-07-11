extends Camera3D
class_name PlayerView

@export var disabled := false

@export var player: Player
@export var rotation_cmp: PlayerRotaitonComponent
@export var controller: PlayerController

@export var item_mesh: MeshInstance3D

func _ready() -> void:
	if disabled:
		set_process(false)
		set_physics_process(false)

func _process(delta: float) -> void:
	if player.disabled_move_camera:
		return
	var camera_delta = controller.camera_delta()
	if !camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotation_cmp.rotate_y(-input_delta.x * player.horizontal_sensitivity)
	rotate_x(-input_delta.y * player.vertical_sensitivity)
	rotation.x = clamp(rotation.x, deg_to_rad(-90) ,deg_to_rad(90))

func set_item(item: ItemManager.Item) -> void:
	item_mesh.mesh = ItemManager.item_mesh.get(item)
