extends Component
class_name PlayerHealthComponent


@export var player: Player

@onready var hp := player.max_hp : set = _hp_change
func _hp_change(value: float) -> void:
	if player.immortal:
		return
	hp = value
	player.hp_changed.emit(player)

func reduce(value: float) -> void:
	hp -= value

func increase(value: float) -> void:
	hp += value

