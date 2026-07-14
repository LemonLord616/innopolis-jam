@abstract
extends ItemResource
class_name AttackItem


@export_range(0.0, 1000.0, 1.0) var damage: float
@export_range(0.0, 10.0, 0.1) var animation_duration: float = 0.3
@export var animation: StringName
@export_range(0.0, 90.0, 1.0) var scope_zoom: float = 0.0


func on_primary_pressed(player: Player, head: Head) -> void:
	pass

func on_primary_released(player: Player, head: Head) -> void:
	pass

func on_secondary_pressed(player: Player, head: Head) -> void:
	pass

func on_secondary_released(player: Player, head: Head) -> void:
	pass
