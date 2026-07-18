extends CharacterBody3D
class_name Projectile


@export var decal_scene: PackedScene
@export var decal_on_boss_hit := false
@export_range(1.0, 100.0, 1.0) var lifetime := 30.0
@export_range(1.0, 100.0, 1.0) var speed := 30.0
@export_range(1.0, 100.0, 1.0) var damage := 10.0
var direction := Vector3.ZERO

@onready var _timer := lifetime
func _physics_process(delta: float) -> void:
	if _timer <= 0:
		queue_free()
	_timer -= delta
	var motion = direction * speed * delta

	var collsision = move_and_collide(motion)

	if not collsision:
		return

	var object = collsision.get_collider()
	var normal := Vector3.DOWN
	if object is BookWalker:
		Damage.SetDamage(object, damage, null) # for now idw to fuck with knockbak
		if not decal_on_boss_hit:
			queue_free()
			return
	else:
		normal = collsision.get_normal()

	# var raycast := RayCast3D.new()
	# get_tree().current_scene.add_child(raycast)
	# raycast.target_position = normal
	# raycast.global_position = collsision.get_position()
	
	var decal: Decal = decal_scene.instantiate()
	get_tree().current_scene.add_child(decal)
	var pos := collsision.get_position()
	decal.global_position = pos
	var y_axis := normal
	var x_axis: Vector3
	if y_axis.is_equal_approx(Vector3.UP):
		x_axis = Vector3.RIGHT.cross(y_axis).normalized()
	else:
		x_axis = Vector3.UP.cross(y_axis).normalized()
	var z_axis = y_axis.cross(x_axis).normalized()
	decal.global_basis = Basis(x_axis, y_axis, z_axis)
	queue_free()
