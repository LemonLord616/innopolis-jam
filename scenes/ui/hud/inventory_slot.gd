extends Panel
class_name InventorySlotUi

@export var item_image: TextureRect
@export var label: Label
@export var outline: Panel

var _selected := false : set = _on_set_selected
func _on_set_selected(value: bool) -> void:
	_selected = value
	outline.visible = _selected

func _ready() -> void:
	outline.visible = false
	
func update_image(item: ItemManager.Item) -> void:
	var texture = ItemManager.item_image.get(item)
	if texture == null:
		Logging.warning(self, "texture is null")
		return
	item_image.texture = texture

func update_number(i: int) -> void:
	label.text = str(i)

func update_selected(flag: bool) -> void:
	_selected = flag
