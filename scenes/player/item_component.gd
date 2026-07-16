extends Component
class_name PlayerItemComponent


@export var player: Player


func _ready() -> void:
	player.controller.hotbar.connect(_on_controller_hotbar)
	player.controller.item_primary.connect(_on_controller_primary)
	player.controller.item_secondary.connect(_on_controller_secondary)
	player.inventory.slot_change.connect(_on_slot_change)

func _on_slot_change(inventory: PlayerInventoryResource) -> void:
	var item := inventory.get_selected_item()
	player.current_item_res = ItemManager.item_resource[item]
	player.head.set_item_res(player.current_item_res)

func _on_controller_hotbar(slot: int) -> void:
	var item_res := player.current_item_res
	if item_res.primary_active or item_res.secondary_active:
		return
	player.inventory.selected_slot = slot

func _on_controller_primary(flag: bool) -> void:
	var item_res := player.current_item_res
	if flag and not item_res.primary_active:
		item_res.primary_pressed(player)
	elif not flag and item_res.primary_active:
		item_res.primary_released(player)

func _on_controller_secondary(flag: bool) -> void:
	var item_res := player.current_item_res
	if flag and not item_res.secondary_active:
		item_res.secondary_pressed(player)
	elif not flag and item_res.secondary_active:
		item_res.secondary_released(player)
