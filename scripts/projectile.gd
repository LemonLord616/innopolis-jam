extends CharacterBody3D
class_name Projectile


@export var decal_scene: PackedScene
@export var decal_on_boss_hit := false
@export_range(1.0, 100.0, 1.0) var speed := 30.0
@export_range(1.0, 100.0, 1.0) var damage := 10.0
var direction := Vector3.ZERO

func _physics_process(delta: float) -> void:
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
	
	var decal: Decal = decal_scene.instantiate()
	get_tree().current_scene.add_child(decal)
	decal.global_position = collsision.get_position()
	decal.look_at(decal.global_position + normal)
	queue_free()
