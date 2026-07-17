extends RotationComponent
class_name Head


@export var disabled := false
@export var player: Player
@export var controller: PlayerController

@export var camera: Camera3D
@export var item_mesh: MeshInstance3D
@export var animation_player: AnimationPlayer


var _current_lib_name: StringName = "hands"
var _current_idle_name: StringName = "idle"

func _ready() -> void:
	if disabled:
		set_process(false)
	# player.inventory.slot_change.connect(_on_selected_slot_change)
	# animation_player.animation_finished.connect(func(_a): play_idle())

func _process(delta: float) -> void:
	if player.effects.disable_move_camera:
		return
	var camera_delta = controller.camera_delta()
	if not camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotate_y(-input_delta.x * player.horizontal_sensitivity)
	camera.rotate_x(-input_delta.y * player.vertical_sensitivity)
	camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))

func set_item(item: ItemResource) -> void:
	if item == null:
		return
	item_mesh.mesh = item.mesh
	_current_lib_name = item.anim_library_name
	_current_idle_name = item.idle_anim_name
	play_idle()
	
# func _on_selected_slot_change(inventory: PlayerInventoryResource) -> void:
# 	var item := inventory.get_selected_item()
# 	var item_res := ItemManager.item_resource[item]

func play_idle() -> void:
	Logging.debug(self, "playing: " + _current_lib_name + "/" + _current_idle_name)
	animation_player.play(_current_lib_name + "/" + _current_idle_name)

func play(anim_name: StringName) -> void:
	Logging.debug(self, "playing: " + _current_lib_name + "/" + anim_name)
	animation_player.play(_current_lib_name + "/" + anim_name)

func item_effect_first() -> void:
	player.inventory.get_selected_item().effect_first(player)

func item_effect_second() -> void:
	player.inventory.get_selected_item().effect_second(player)
