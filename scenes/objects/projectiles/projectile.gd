extends Area3D
class_name Projectile

@export var damage: float = 10.0
@export var speed: float = 20.0
@export var lifetime: float = 5.0

var direction: Vector3 = Vector3.FORWARD

func _ready() -> void:
	body_entered.connect(_on_hit)
	area_entered.connect(_on_hit)
	await get_tree().create_timer(lifetime, false).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_hit(_hit: Node) -> void:
	var hc := _resolve_health(_hit)
	if hc != null:
		hc.reduce(damage)
	queue_free()

func _resolve_health(node: Node) -> HealthComponent:
	if node.has_node("HealthComponent"):
		return node.get_node("HealthComponent") as HealthComponent
	var parent = node.get_parent()
	if parent and parent.has_node("HealthComponent"):
		return parent.get_node("HealthComponent") as HealthComponent
	return null
