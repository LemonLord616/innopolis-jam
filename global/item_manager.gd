extends Node
class_name ItemManager

enum Item {
	PLACEHOLDER
}

static var item_resources: Dictionary[Item, ItemResource] = {
	Item.PLACEHOLDER: preload("res://resources/items/placeholder.tres") as ItemResource
}
