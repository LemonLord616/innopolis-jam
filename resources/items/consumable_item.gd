extends ItemResource
class_name ConsumableItem


@export var effect: Effect

func apply_effect(player: Player) -> void:
	effect.apply(player)
