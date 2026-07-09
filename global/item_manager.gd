extends Node
class_name ItemManager

enum Item {
	NOITEM,
	PLACEHOLDER
}

static var item_info: Dictionary[Item, ItemInfo] = {
	Item.NOITEM: preload("res://resources/items/noitem_info.tres") as ItemInfo,
	Item.PLACEHOLDER: preload("res://resources/items/placeholder_info.tres") as ItemInfo
}

static var item_image: Dictionary[Item, Texture2D] = {
	Item.NOITEM: preload("res://icon.svg") as Texture2D,
	Item.PLACEHOLDER: preload("res://assets/placeholder_preview.png") as Texture2D
}

static var item_mesh: Dictionary[Item, Mesh] = {
	Item.PLACEHOLDER: preload("res://assets/placeholder.tres") as Mesh
}

static func item_name(item: ItemManager.Item) -> String:
	var info = item_info.get(item)
	if info == null:
		Logging.warning(null, "ItemManager: no available info for item " + str(item))
		return ""
	return info.name
