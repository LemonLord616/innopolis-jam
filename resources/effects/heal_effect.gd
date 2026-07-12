extends Effect
class_name HealEffect


@export_range(0.0, 100.0, 1.0) var amount: float

func apply(player: Player) -> void:
	player.hp += amount
