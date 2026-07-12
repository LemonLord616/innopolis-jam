extends CharacterBody3D
class_name BossActor


@export var rotation_cmp: RotationComponent
@export var head: MeshInstance3D

func head_look_at(target: Vector3) -> void:
	head.look_at(target)

func body_look_at(target: Vector3) -> void:
	var dist = target - global_position
	rotation_cmp.rotation.y = atan2(-dist.x, -dist.z)
