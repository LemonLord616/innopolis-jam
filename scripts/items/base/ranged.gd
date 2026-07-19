@abstract
extends Weapon
class_name Ranged

@export var projectile_scene: PackedScene

@abstract
func spawn_projectile(player: Player, origin: Vector3, direction: Vector3) -> void
