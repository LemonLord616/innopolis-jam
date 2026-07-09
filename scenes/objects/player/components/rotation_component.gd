extends Component3D
class_name PlayerRotaitonComponent

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)