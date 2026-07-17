extends Component3D
class_name RotationComponent

func facing_dir() -> Vector3:
	return -global_basis.z

func rotated_vec(vec: Vector3) -> Vector3:
	return vec.rotated(Vector3.UP, global_rotation.y)
