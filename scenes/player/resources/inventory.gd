extends Resource
class_name PlayerInventoryResource

signal inventory_change(PlayerInventoryResource)
signal slot_change(PlayerInventoryResource)

@export var slots: Array[ItemResource]

var selected_slot := 0 : set = _selected_slot_change
func _selected_slot_change(value: int) -> void:
	if value < 0 or value >= slots.size():
		return
	selected_slot = value
	slot_change.emit(self)

func get_selected_item() -> ItemResource:
	return slots.get(selected_slot)

func _init() -> void:
	inventory_change.emit.call_deferred(self)
	slot_change.emit.call_deferred(self)

func set_item(slot: int, item: ItemResource) -> void:
	slots.set(slot, item)
	inventory_change.emit(self)

func get_item(slot: int) -> ItemResource:
	return slots.get(slot)

func has_item(item: ItemResource) -> bool:
	return slots.has(item)

func is_occupied(slot: int) -> bool:
	return slots.get(slot) != null

func add_item(item: ItemResource) -> void:
	slots.append(item)
	inventory_change.emit(self)
	selected_slot = slots.size() - 1
