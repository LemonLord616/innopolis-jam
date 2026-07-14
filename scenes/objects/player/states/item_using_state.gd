extends State
class_name PlayerItemUsingState


@export var player: Player
@export var controller: PlayerController
@export var head: Head
@export var ready_state: PlayerItemUseReadyState


var _interrupted := false
var _interruptible := false
var _current_hitbox: MeleeHitbox


func enter() -> void:
	controller.item_primary.connect(_on_item_primary)
	player.effects.disable_change_slot = true
	player.effects.disable_attack = true

func exit() -> void:
	controller.item_primary.disconnect(_on_item_primary)
	player.effects.disable_change_slot = false
	player.effects.disable_attack = false
	_interrupted = false
	_cleanup_hitbox()

func _on_item_primary(pressed: bool) -> void:
	if not pressed and _interruptible:
		_interrupted = true


func start_melee(item: MeleeItem) -> void:
	_interruptible = false
	if item.animation:
		head.animation_player.play(item.animation)
	if item.hitbox_delay > 0.0:
		await get_tree().create_timer(item.hitbox_delay, false).timeout
		if _interrupted:
			_finish()
			return
	_spawn_melee_hitbox(item)
	if item.hitbox_lifetime > 0.0:
		await get_tree().create_timer(item.hitbox_lifetime, false).timeout
	_finish()

func start_consuming(item: ConsumableItem) -> void:
	_interruptible = GlobalSettings.consumable_interruptible
	if item.consume_animation:
		head.animation_player.play(item.consume_animation)
	var t := item.consume_duration
	while t > 0.0:
		await get_tree().process_frame
		t -= get_process_delta_time()
		if _interrupted:
			_finish()
			return
	item.apply_effect(player)
	player.inventory.decrement_slot(player.selector.get_selected_slot(), 1)
	_finish()

func _spawn_melee_hitbox(item: MeleeItem) -> void:
	if item.swing_hitbox == null:
		return
	var hitbox := item.swing_hitbox.instantiate() as MeleeHitbox
	if hitbox == null:
		return
	hitbox.damage = item.damage
	hitbox.lifetime = item.hitbox_lifetime
	hitbox.damage_interval = item.hitbox_damage_interval
	hitbox.self_destruct = item.hitbox_lifetime > 0.0
	hitbox.global_position = head.global_position - head.global_basis.z * 1.5
	hitbox.global_basis = head.global_basis
	player.add_child(hitbox)
	_current_hitbox = hitbox

func _cleanup_hitbox() -> void:
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	_current_hitbox = null

func _finish() -> void:
	_cleanup_hitbox()
	switch_to_state.emit(self, ready_state)
