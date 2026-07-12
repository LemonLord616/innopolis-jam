@abstract
extends Resource
class_name Effect

@export var name: StringName

@abstract
func apply(player: Player) -> void
