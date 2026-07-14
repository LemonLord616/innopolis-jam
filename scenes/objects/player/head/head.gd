extends RotationComponent
class_name Head


@export var disabled := false
@export var player: Player
@export var controller: PlayerController

@onready var camera: Camera3D = $Camera3D
@onready var item_mesh: MeshInstance3D = $Item
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area3D = $Hitbox


func _ready() -> void:
	if disabled:
		set_process(false)

func _process(delta: float) -> void:
	if player.effects.disable_move_camera:
		return
	var camera_delta = controller.camera_delta()
	if not camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotate_y(-input_delta.x * player.horizontal_sensitivity)
	rotate_x(-input_delta.y * player.vertical_sensitivity)
	rotation.x = clampf(rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))

func set_item(item: ItemManager.Item) -> void:
	var res = ItemManager.item_resource.get(item)
	if res == null:
		item_mesh.mesh = null
		return
	item_mesh.mesh = res.mesh
