@abstract
extends AttackItem
class_name MeleeItem

@export var swing_hitbox: PackedScene
@export_range(0.0, 10.0, 0.01) var hitbox_delay: float = 0.0
@export_range(0.0, 10.0, 0.01) var hitbox_lifetime: float = 0.1
@export_range(0.0, 10.0, 0.01) var hitbox_damage_interval: float = 0.0
