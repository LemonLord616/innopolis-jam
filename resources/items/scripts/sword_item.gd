extends MeleeItem
class_name SwordItem


func on_primary_pressed(player: Player, head: Head) -> void:
	if player.effects.disable_attack:
		return
	player.item_using_state.start_melee(self)

func on_secondary_pressed(player: Player, head: Head) -> void:
	pass
