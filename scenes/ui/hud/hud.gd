extends Control
class_name Hud


@export var player: Player

@export var inventory_cntr: InventoryContainer
@export var hp_bar: ProgressBar
@export var dash_cooldown_bar: ProgressBar

func _ready() -> void:
	player.inventory.change.connect(inventory_cntr._build_slots)
	player.selector.change.connect(inventory_cntr._update_selected)
	hp_bar.max_value = player.max_hp
	dash_cooldown_bar.max_value = player.dash_cooldown_duration

func _physics_process(delta: float) -> void:
	hp_bar.value = player.hp
	var value: float
	if player.dash_active:
		value = 0
	else:
		value = player.dash_cooldown_duration - player.dash_cooldown_timer.time_left
	dash_cooldown_bar.value = value
