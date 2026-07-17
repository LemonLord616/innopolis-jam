extends ProlongedEffect
class_name StunEffect

func start(player: Player) -> void:
	player.effects.disable_move = true
	player.effects.disable_dash = true

func end(player: Player) -> void:
	player.effects.disable_move = false
	player.effects.disable_dash = false
