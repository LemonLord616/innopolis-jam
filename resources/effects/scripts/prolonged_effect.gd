@abstract
extends Effect
class_name ProlongedEffect

@export_range(0.0, 100.0, 0.5) var duration: float

# signal started(ProlongedEffect)
signal ended(ProlongedEffect)

@abstract
func start(player: Player) -> void

@abstract
func end(player: Player) -> void

func apply(player: Player) -> void:
	start(player)
	await_timer(player)
	end(player)
	ended.emit(self)

func await_timer(player: Player) -> void:
	if duration > 0.0:
		await player.get_tree().create_timer(duration, false).timeout
