extends Node
class_name ItemManager

enum Item {
	NOITEM,
	PLACEHOLDER,
	SWORD,
	BOW,
	HEALTH_POTION
}

static var item_resource: Dictionary[Item, ItemResource] = {
	Item.NOITEM: preload("res://resources/items/data/noitem.tres") as ItemResource,
	Item.PLACEHOLDER: preload("res://resources/items/data/placeholder.tres") as ItemResource,
	Item.SWORD: preload("res://resources/items/data/sword.tres") as ItemResource,
	Item.BOW: preload("res://resources/items/data/bow.tres") as ItemResource,
	Item.HEALTH_POTION: preload("res://resources/items/data/health_potion.tres") as ItemResource
}

static func item_name(item: ItemManager.Item) -> String:
	var info = item_resource.get(item)
	if info == null:
		Logging.warning(null, "ItemManager: no available info for item " + str(item))
		return ""
	return info.name
