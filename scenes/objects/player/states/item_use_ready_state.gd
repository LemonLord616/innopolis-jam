extends State
class_name PlayerItemUseReadyState


@export var player: Player
@export var controller: PlayerController
@export var head: Head
@export var using_state: PlayerItemUsingState


func enter() -> void:
	controller.item_primary.connect(_on_item_primary)
	controller.item_secondary.connect(_on_item_secondary)

func exit() -> void:
	controller.item_primary.disconnect(_on_item_primary)
	controller.item_secondary.disconnect(_on_item_secondary)

func _on_item_primary(pressed: bool) -> void:
	var item_enum = player.selector.get_selected_item()
	var item_res = ItemManager.item_resource.get(item_enum)
	if item_res == null or item_res is ItemResource == false:
		return
	if pressed:
		if item_res is MeleeItem:
			if player.effects.disable_attack:
				return
			switch_to_state.emit(self, using_state)
			using_state.start_melee(item_res as MeleeItem)
		elif item_res is ConsumableItem:
			if player.effects.disable_attack:
				return
			switch_to_state.emit(self, using_state)
			using_state.start_consuming(item_res as ConsumableItem)
		elif item_res is AttackItem:
			(item_res as AttackItem).on_primary_pressed(player, head)
	else:
		if item_res is AttackItem:
			(item_res as AttackItem).on_primary_released(player, head)

func _on_item_secondary(pressed: bool) -> void:
	var item_enum = player.selector.get_selected_item()
	var item_res = ItemManager.item_resource.get(item_enum)
	if item_res == null or item_res is ItemResource == false:
		return
	if pressed:
		if item_res is AttackItem:
			(item_res as AttackItem).on_secondary_pressed(player, head)
	else:
		if item_res is AttackItem:
			(item_res as AttackItem).on_secondary_released(player, head)
