extends HBoxContainer
class_name InventoryContainer

@onready var slot_scene := preload("res://scenes/ui/hud/inventory_slot.tscn")

var _slots: Array[InventorySlotUi] = []

func _build_slots(inventory: PlayerInventoryResource) -> void:
	for slot in _slots:
		remove_child(slot)
		slot.queue_free()
	_slots = []
	for slot in get_children():
		remove_child(slot)
		slot.queue_free()
	for i in inventory.stacks.size():
		var slot: InventorySlotUi = slot_scene.instantiate()
		add_child(slot)
		_slots.append(slot)
		var item = inventory.get_item(i)
		Logging.debug(self, "add item: " + ItemManager.item_name(item))
		slot.update_image(item)
		slot.update_number(i)

func _update_selected(selector: PlayerInventorySelectorComponent) -> void:
	var i = selector.get_selected_slot()
	if i >= _slots.size() or i < 0:
		return
	for slot in _slots:
		slot.update_selected(false)
	var slot = _slots.get(i)
	if slot == null:
		Logging.warning(self, "selector slot not in slots array")
		return
	slot.update_selected(true)
