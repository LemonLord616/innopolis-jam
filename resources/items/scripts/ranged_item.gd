@abstract
extends AttackItem
class_name RangedItem

@export var projectile_scene: PackedScene
@export_range(1.0, 100.0, 1.0) var projectile_speed: float = 20.0


func spawn_projectile(player: Player, origin: Vector3, direction: Vector3) -> void:
	if projectile_scene == null:
		return
	var proj := projectile_scene.instantiate() as Projectile
	if proj == null:
		return
	proj.damage = damage
	proj.speed = projectile_speed
	proj.global_position = origin
	proj.direction = direction
	player.get_parent().add_child(proj)
