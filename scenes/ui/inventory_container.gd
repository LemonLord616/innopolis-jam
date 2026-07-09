extends HBoxContainer
class_name InventoryContainer

@onready var slot_scene := preload("res://scenes/ui/inventory_slot.tscn")

var _slots: Array[InventorySlotUi] = []

func _build_slots(data: PlayerInventoryResource) -> void:
	for slot in _slots:
		remove_child(slot)
		slot.queue_free()
	_slots = []
	for slot in get_children():
		remove_child(slot)
		slot.queue_free()
	for i in data.max_slots:
		var slot: InventorySlotUi = slot_scene.instantiate()
		add_child(slot)
		_slots.append(slot)
		var item = data.get_item(i)
		Logging.debug(self, "add item: " + ItemManager.item_name(item))
		slot.update_image(item)
		slot.update_number(i)

func _update_selected(selected: int) -> void:
	for slot in _slots:
		slot.update_selected(false)
	var slot = _slots.get(selected)
	if slot == null:
		Logging.warning(self, "selected slot not in slots array")
		return
	slot.update_selected(true)
