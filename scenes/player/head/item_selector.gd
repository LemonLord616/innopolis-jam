extends Component3D
class_name HeadItemSelector


@export var ink_pen: Node3D
@export var telescope: Node3D
@export var umbrella: Node3D

var _current_item: ItemManager.Item = ItemManager.Item.NOITEM

@onready var items: Dictionary[ItemManager.Item, Node3D] = {
	ItemManager.Item.INK_SCYTHE: ink_pen,
	ItemManager.Item.TELESCOPE: telescope,
	ItemManager.Item.UMBRELLA: umbrella,
}

func set_item(item: ItemManager.Item) -> void:
	if _current_item != ItemManager.Item.NOITEM:
		_deactivate_item(items[_current_item])
	if item != ItemManager.Item.NOITEM:
		_activate_item(items[item])
	_current_item = item

func _activate_item(item: Node3D) -> void:
	item.process_mode = PROCESS_MODE_INHERIT
	item.visible = true

func _deactivate_item(item: Node3D) -> void:
	item.visible = false
	item.process_mode = PROCESS_MODE_DISABLED
