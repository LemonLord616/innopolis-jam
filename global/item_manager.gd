extends Node
class_name ItemManager

enum Item {
	NOITEM,
	INK_SCYTHE,
}

static var item_resource: Dictionary[Item, ItemResource] = {
	Item.NOITEM: preload("res://resources/items/data/hands.tres") as MeleeHands,
	Item.INK_SCYTHE: preload("res://resources/items/data/ink_scythe.tres") as InkScythe,
}

static func item_name(item: ItemManager.Item) -> String:
	var info = item_resource.get(item)
	if info == null:
		Logging.warning(null, "ItemManager: no available info for item " + str(item))
		return ""
	return info.name
