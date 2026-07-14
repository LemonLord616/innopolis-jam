extends RangedItem
class_name BowItem


@export_range(0.1, 5.0, 0.1) var charge_time: float = 1.0

var _charging := false


func on_primary_pressed(player: Player, head: Head) -> void:
	if player.effects.disable_attack:
		return
	_charging = true
	if animation:
		head.animation_player.play(animation)

func on_primary_released(player: Player, head: Head) -> void:
	if not _charging:
		return
	_charging = false
	var origin = head.global_position
	var direction = -head.global_basis.z
	spawn_projectile(player, origin, direction)

func on_secondary_pressed(player: Player, head: Head) -> void:
	pass
