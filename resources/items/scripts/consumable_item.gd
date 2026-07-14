extends ItemResource
class_name ConsumableItem


@export var effect: Effect
@export_range(0.0, 10.0, 0.1) var consume_duration: float = 1.0
@export var consume_animation: StringName


func apply_effect(player: Player) -> void:
	effect.apply(player)
