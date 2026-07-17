extends Resource
class_name PlayerInventoryResource

signal inventory_change(PlayerInventoryResource)
signal slot_change(PlayerInventoryResource)

@export var slots: Array[ItemManager.Item]

var selected_slot := 0 : set = _selected_slot_change
func _selected_slot_change(value: int) -> void:
	if value < 0 or value >= slots.size():
		return
	selected_slot = value
	slot_change.emit(self)

func get_selected_item() -> ItemManager.Item:
	return slots.get(selected_slot)

func _init() -> void:
	inventory_change.emit.call_deferred(self)
	slot_change.emit.call_deferred(self)

func set_item(slot: int, item: ItemManager.Item, soft: bool = true) -> bool:
	if slot < 0 or slot >= slots.size():
		return false
	if slots.get(slot) != ItemManager.Item.NOITEM and soft:
		return false
	slots.set(slot, item)
	inventory_change.emit(self)
	return true

func get_item(slot: int) -> ItemManager.Item:
	if slot < 0 or slot >= slots.size():
		return ItemManager.Item.NOITEM
	return slots.get(slot)

func has_item(item: ItemManager.Item) -> bool:
	return slots.has(item)

func is_occupied(slot) -> bool:
	return slots.get(slot) != null
