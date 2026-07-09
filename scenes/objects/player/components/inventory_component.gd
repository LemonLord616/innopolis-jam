extends Component
class_name PlayerInventoryComponent


@export var data: PlayerInventoryResource
@export var controller: PlayerController

signal selected_change(slot: int)

var selected_slot := 0 : set = _set_selected_slot
func _set_selected_slot(value: int) -> void:
	selected_slot = value
	Logging.debug(self, "selected slot " + str(selected_slot))
	selected_change.emit(selected_slot)

func _ready() -> void:
	controller.hotbar.connect(select_slot)
	selected_change.emit.call_deferred(selected_slot)

func select_slot(slot: int) -> bool:
	if slot < 0 or slot >= data.max_slots:
		return false
	selected_slot = slot
	return true

func get_selected_item() -> ItemManager.Item:
	return data.get_item(selected_slot)

func is_occupied(slot: int) -> bool:
	return data.is_occupied(slot)

func set_item(slot: int, item: ItemManager.Item) -> bool:
	return data.set_item(slot, item)

func remove_item(slot: int) -> bool:
	return data.set_item(slot, ItemManager.Item.NOITEM, false)

func has_item(item: ItemManager.Item) -> bool:
	return data.has_item(item)
