extends Ranged
class_name Telescope


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

func effect_first(player: Player) -> void:
	spawn_projectile(player, player.global_position, player.head.look_dir())
func effect_second(player: Player) -> void:
	pass

func spawn_projectile(player: Player, origin: Vector3, direction: Vector3) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	player.get_tree().current_scene.add_child(projectile)
	projectile.direction = direction
	projectile.global_position = origin
