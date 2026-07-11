extends Component
class_name PlayerInventorySelectorComponent


@export var player: Player
@export var controller: PlayerController
@export var player_view: PlayerView

signal change(component: PlayerInventorySelectorComponent)

var _selected_slot := 0

func _ready() -> void:
	controller.hotbar.connect(select_slot)
	select_slot(_selected_slot)

func select_slot(slot: int) -> bool:
	if player.disabled_change_slot:
		return false
	if slot < 0 or slot >= player.inventory.slots.size():
		return false
	_selected_slot = slot
	change.emit(self)
	player_view.set_item(player.inventory.get_item(_selected_slot))
	Logging.debug(self, "selected slot " + str(_selected_slot))
	return true

func get_selected_slot() -> int:
	return _selected_slot

func get_selected_item() -> ItemManager.Item:
	return player.inventory.get_item(_selected_slot)
