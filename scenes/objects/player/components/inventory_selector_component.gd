extends Component
class_name PlayerInventorySelectorComponent


@export var player: Player
@export var controller: PlayerController
@export var player_view: PlayerView

var selected_slot := 0 : set = _selected_slot_change
func _selected_slot_change(value: int) -> void:
	if player.disable_change_slot:
		return
	if value < 0 or value >= player.inventory.slots.size():
		return
	selected_slot = value
	player_view.set_item(player.inventory.get_item(player.selected_slot))
	player.selected_slot_changed.emit(player)
	Logging.debug(self, "selected slot " + str(selected_slot))

func _ready() -> void:
	controller.hotbar.connect(_on_controller_hotbar)

func _on_controller_hotbar(slot: int) -> bool:
	player.selected_slot = slot
	return true


	
