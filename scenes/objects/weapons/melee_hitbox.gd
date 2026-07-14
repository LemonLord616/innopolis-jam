extends Area3D
class_name MeleeHitbox

@export var damage: float = 10.0

var lifetime: float = 0.1
var damage_interval: float = 0.0
var self_destruct: bool = true

var _already_hit: Array[Node] = []
var _age: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	_age += delta
	if self_destruct and _age >= lifetime:
		queue_free()
		return
	if damage_interval > 0.0:
		var elapsed = fmod(_age, damage_interval)
		var prev = elapsed - delta
		if prev < 0.0 or elapsed < prev:
			_already_hit.clear()

func _on_body_entered(body: Node) -> void:
	if body in _already_hit:
		return
	_already_hit.append(body)
	var hc := _resolve_health(body)
	if hc != null:
		hc.reduce(damage)

func _resolve_health(node: Node) -> HealthComponent:
	if node.has_node("HealthComponent"):
		return node.get_node("HealthComponent") as HealthComponent
	var parent = node.get_parent()
	if parent and parent.has_node("HealthComponent"):
		return parent.get_node("HealthComponent") as HealthComponent
	return null
