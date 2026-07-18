extends Decal
class_name LifetimeDecal


@export_range(1.0, 100.0, 1.0) var lifetime := 30.0

@onready var _timer = lifetime
func _physics_process(delta: float) -> void:
	if _timer <= 0:
		queue_free()
	_timer -= delta
