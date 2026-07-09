extends Camera3D
class_name CameraController

@export var player: Player
@export var rotation_cmp: PlayerRotaitonComponent
@export var controller: PlayerController

func _process(delta: float) -> void:
	var camera_delta = controller.camera_delta()
	if !camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotation_cmp.rotate_y(-input_delta.x * player.horizontal_sensitivity)
	rotate_x(-input_delta.y * player.vertical_sensitivity)
	rotation.x = clamp(rotation.x, deg_to_rad(-90) ,deg_to_rad(90))
