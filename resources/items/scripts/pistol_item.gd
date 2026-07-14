extends RangedItem
class_name PistolItem


func on_primary_pressed(player: Player, head: Head) -> void:
	if player.effects.disable_attack:
		return
	var origin = head.global_position
	var direction = -head.global_basis.z
	spawn_projectile(player, origin, direction)
	if animation:
		head.animation_player.play(animation)

func on_secondary_pressed(player: Player, head: Head) -> void:
	pass
