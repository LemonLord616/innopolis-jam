extends Node
class_name ItemManager

enum Item {
	NOITEM,
	INK_SCYTHE,
	TELESCOPE,
	UMBRELLA
}

static var item_resource: Dictionary[Item, ItemResource] = {
	Item.NOITEM: preload("res://resources/items/hands.tres") as MeleeHands,
	Item.INK_SCYTHE: preload("res://resources/items/ink_scythe.tres") as InkScythe,
	Item.TELESCOPE: preload("res://resources/items/telescope.tres") as Telescope,
	Item.UMBRELLA: preload("res://resources/items/umbrella(hands).tres") as MeleeHands,
}

static func item_name(item: ItemManager.Item) -> String:
	var info = item_resource.get(item)
	if info == null:
		Logging.warning(null, "ItemManager: no available info for item " + str(item))
		return ""
	return info.name
