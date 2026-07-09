extends InterruptiveComponent
class_name PlayerInventorySelectorComponent


@export var player: Player
@export var controller: PlayerController
@export var player_view: PlayerView

signal change(component: PlayerInventorySelectorComponent)
signal gonna_change(component: InterruptiveComponent)

var _selected_slot := 0

func _ready() -> void:
	controller.hotbar.connect(select_slot)
	select_slot(_selected_slot)

func select_slot(slot: int) -> bool:
	if slot < 0 or slot >= player.inventory.slots.size():
		return false
	_interrupted = false
	gonna_change.emit(self)
	if _interrupted:
		return false
	_selected_slot = slot
	player_view.set_item(player.inventory.get_item(_selected_slot))
	Logging.debug(self, "selected slot " + str(_selected_slot))
	change.emit(self)
	return true

func get_selected_slot() -> int:
	return _selected_slot

func get_selected_item() -> ItemManager.Item:
	return player.inventory.get_item(_selected_slot)
