extends Melee
class_name InkScythe


@export var ink_scene: PackedScene

var _player: Player = null

func _on_animation_finished(_anim_name: StringName) -> void:
	_player.head.animation_player.animation_finished.disconnect(_on_animation_finished)
	_player.head.play_idle()
	primary_active = false

func primary_pressed(player: Player) -> void:
	primary_active = true
	_player = player
	_player.head.animation_player.animation_finished.connect(_on_animation_finished)
	_player.head.play(attack_anim_name)
func primary_released(player: Player) -> void:
	pass
func secondary_pressed(player: Player) -> void:
	secondary_active = false
func secondary_released(player: Player) -> void:
	pass
