extends Resource
class_name PlayerResource

@export var items: Array[ItemManager.Item]
@export var max_slots := 4


func _init() -> void:
	items.resize(max_slots)

func set_item(slot: int, item: ItemManager.Item, soft: bool = true) -> bool:
	if slot < 0 or slot >= max_slots:
		return false
	if items.get(slot) != null and soft:
		return false
	items.set(slot, item)
	return true

func get_item(slot: int) -> ItemManager.Item:
	return items.get(slot)

func has_item(item: ItemManager.Item) -> bool:
	return items.has(item)

func is_occupied(slot) -> bool:
	return items.get(slot) != null
