extends Control
class_name Ui


@export var player: Player

@export var inventory_cntr: InventoryContainer

func _ready() -> void:
	player.inventory.change.connect(inventory_cntr._build_slots)
	player.selector.change.connect(inventory_cntr._update_selected)
