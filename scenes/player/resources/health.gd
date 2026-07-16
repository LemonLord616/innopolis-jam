extends Resource
class_name PlayerHealthResource

signal hp_changed(current: float, max_hp: float)
signal died
signal recovered

@export_range(0.0, 1000.0, 1.0) var max_hp: float
@export_range(0.0, 1000.0, 1.0) var hp_at_spawn: float

func reset() -> void:
	hp = hp_at_spawn

var _dead := false : set = _on_dead_change
func _on_dead_change(value: bool) -> void:
	if value == _dead:
		return
	_dead = value
	if _dead:
		died.emit()
	else:
		recovered.emit()

var hp := max_hp : set = _on_hp_change
func _on_hp_change(value: float) -> void:
	if value == hp:
		return
	hp = clampf(value, 0.0, max_hp)
	hp_changed.emit(hp, max_hp)
	_dead = hp <= 0.0

func reduce(amount: float) -> void:
	hp -= amount

func increase(amount: float) -> void:
	hp += amount
