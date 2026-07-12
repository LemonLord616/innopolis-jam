extends Component
class_name HealthComponent

signal hp_changed(float)
signal died
signal recovered

@export var player: Player

var _dead := false : set = _on_dead_change
func _on_dead_change(value: bool) -> void:
	if value == _dead:
		return
	_dead = value
	if _dead: died.emit()
	else: recovered.emit()

@onready var hp := player.max_hp : set = _on_hp_change
func _on_hp_change(value: float) -> void:
	if value == hp:
		return
	hp = clampf(value, 0.0, player.max_hp)
	hp_changed.emit(hp)
	_dead = hp <= 0.0

func reduce(amount: float) -> void:
	hp -= amount

func increase(amount: float) -> void:
	hp += amount
