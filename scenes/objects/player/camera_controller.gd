extends Camera3D
class_name CameraController

@export var rotation_cmp: RotaitonComponent
@export var controller: PlayerController
@export_range(0.0001, 0.1, 0.0001) var sensitivity: float = 0.005

func _process(delta: float) -> void:
	var camera_delta = controller.camera_delta()
	if !camera_delta.is_zero_approx():
		apply_camera_movement(camera_delta)

func apply_camera_movement(input_delta: Vector2) -> void:
	rotation_cmp.rotate_y(-input_delta.x * sensitivity)
	rotate_x(-input_delta.y * sensitivity)
	rotation.x = clamp(rotation.x, deg_to_rad(-90) ,deg_to_rad(90))
