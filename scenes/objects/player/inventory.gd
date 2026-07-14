extends Resource
class_name PlayerInventoryResource

signal change(data: PlayerInventoryResource)

@export var slots: Array[ItemManager.Item]


func _init() -> void:
	change.emit.call_deferred(self)

func set_item(slot: int, item: ItemManager.Item, soft: bool = true) -> bool:
	if slot < 0 or slot >= slots.size():
		return false
	if slots.get(slot) != null and soft:
		return false
	slots.set(slot, item)
	change.emit(self)
	return true

func get_item(slot: int) -> ItemManager.Item:
	if slot < 0 or slot >= slots.size():
		return ItemManager.Item.NOITEM
	return slots.get(slot)

func has_item(item: ItemManager.Item) -> bool:
	return slots.has(item)

func is_occupied(slot) -> bool:
	return slots.get(slot) != null

func decrement_slot(slot: int, _amount: int = 1) -> void:
	if slot < 0 or slot >= slots.size():
		return
	slots.set(slot, ItemManager.Item.NOITEM)
	change.emit(self)
