extends Control
class_name Hud


@export var player: Player

@export var inventory_cntr: InventoryContainer
@export var hp_bar: ProgressBar
@export var dash_cooldown_bar: ProgressBar

func _ready() -> void:
	player.inventory.inventory_change.connect(inventory_cntr._build_slots)
	player.inventory.slot_change.connect(inventory_cntr._update_selected)
	player.health.hp_changed.connect(_on_hp_changed)
	hp_bar.max_value = player.health.max_hp
	dash_cooldown_bar.max_value = player.dash_cooldown_duration

func _on_hp_changed(hp: float, max_hp: float) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp

func _physics_process(_delta: float) -> void:
	var value: float
	if player.dash_active:
		value = 0
	else:
		value = player.dash_cooldown_duration - player.dash_cooldown_timer.time_left
	dash_cooldown_bar.value = value
