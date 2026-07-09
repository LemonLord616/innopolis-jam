extends Control
class_name Ui


@export var player: Player

@export var inventory_cntr: InventoryContainer

func _ready() -> void:
	player.inventory_cmp.data.inventory_change.connect(inventory_cntr._build_slots)
	player.inventory_cmp.selected_change.connect(inventory_cntr._update_selected)
