extends Component
class_name PlayerItemComponent


@export var player: Player


func _ready() -> void:
	player.controller.hotbar.connect(_on_controller_hotbar)
	player.controller.item_primary.connect(_on_controller_primary)
	player.controller.item_secondary.connect(_on_controller_secondary)
	player.inventory.slot_change.connect(_on_slot_change)

func _on_slot_change(inventory: PlayerInventoryResource) -> void:
	player.head.set_item(player.inventory.get_selected_item())

func _on_controller_hotbar(slot: int) -> void:
	var item := player.inventory.get_selected_item()
	if item.primary_active or item.secondary_active:
		return
	player.inventory.selected_slot = slot

func _on_controller_primary(flag: bool) -> void:
	var item := player.inventory.get_selected_item()
	if item == null:
		return
	if flag and not item.primary_active:
		item.primary_pressed(player)
	elif not flag and item.primary_active:
		item.primary_released(player)

func _on_controller_secondary(flag: bool) -> void:
	var item := player.inventory.get_selected_item()
	if item == null:
		return
	if flag and not item.secondary_active:
		item.secondary_pressed(player)
	elif not flag and item.secondary_active:
		item.secondary_released(player)
