extends State
class_name PlayerItemUseReadyState


@export var player: Player
@export var controller: PlayerController

func enter() -> void:
	controller.item_primary.connect(_on_item_primary)
	controller.item_secondary.connect(_on_item_secondary)
func exit() -> void:
	controller.item_primary.disconnect(_on_item_primary)
	controller.item_secondary.disconnect(_on_item_secondary)

func _on_item_primary(flag: bool) -> void:
	pass

func _on_item_secondary(flag: bool) -> void:
	pass
