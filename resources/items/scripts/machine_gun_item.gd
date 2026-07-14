extends RangedItem
class_name MachineGunItem


@export_range(0.05, 2.0, 0.05) var fire_rate: float = 0.15

var _firing := false


func on_primary_pressed(player: Player, head: Head) -> void:
	if player.effects.disable_attack:
		return
	_firing = true
	_fire(player, head)

func _fire(player: Player, head: Head) -> void:
	if not _firing:
		return
	var origin = head.global_position
	var direction = -head.global_basis.z
	spawn_projectile(player, origin, direction)
	if animation:
		head.animation_player.play(animation)
	await player.get_tree().create_timer(fire_rate, false).timeout
	_fire(player, head)

func on_primary_released(player: Player, head: Head) -> void:
	_firing = false
