extends Area3D
class_name WorldItem


@export var item_resource: ItemResource
@export var effect: Effect
@export var destroy_on_pickup := true

var _picked_up := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if _picked_up:
		return
	if not (body is Player):
		return
	_picked_up = true

	var player := body as Player

	if effect != null:
		effect.apply(player)

	if item_resource != null:
		player.inventory.add_item(item_resource)

	if destroy_on_pickup:
		queue_free()
