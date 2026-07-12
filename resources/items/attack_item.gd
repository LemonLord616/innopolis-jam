@abstract
extends ItemResource
class_name AttackItem


@export_range(0.0, 100.0, 1.0) var damage: float
@export_range(0.0, 5.0, 0.1) var duration: float

@abstract
func attack(boss: Boss) -> void