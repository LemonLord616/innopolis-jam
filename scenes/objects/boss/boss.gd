extends Node3D
class_name Boss

@export var player: Player
@export var actor: BossActor

func _physics_process(delta: float) -> void:
	actor.body_look_at(player.global_position)
	actor.head_look_at(player.global_position)
