extends Component
class_name PlayerInventorySelectorComponent


@export var player: Player
@export var controller: PlayerController
@export var head: Head

signal change(component: PlayerInventorySelectorComponent)

var selected_slot := 0 : set = _selected_slot_change

func _selected_slot_change(value: int) -> void:
	if player.effects.disable_change_slot:
		return
	if value < 0 or value >= player.inventory.slots.size():
		return
	selected_slot = value
	head.set_item(player.inventory.get_item(selected_slot))
	change.emit(self)
	Logging.debug(self, "selected slot " + str(selected_slot))

func _ready() -> void:
	controller.hotbar.connect(_on_controller_hotbar)
	selected_slot = 0

func _on_controller_hotbar(slot: int) -> void:
	selected_slot = slot

func get_selected_slot() -> int:
	return selected_slot

func get_selected_item() -> ItemManager.Item:
	return player.inventory.get_item(selected_slot)
