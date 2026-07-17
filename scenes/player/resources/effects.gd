extends Resource
class_name PlayerEffectsResource


# @export var active: Array[ProlongedEffect]

signal disable_jump_changed(bool)
signal disable_dash_changed(bool)
signal disable_move_changed(bool)
signal disable_move_camera_changed(bool)
signal disable_change_slot_changed(bool)
# would be funny if boss reacts on this, saying "cheater"
signal immortal_changed(bool)
signal disable_item_changed(bool)
signal infinite_jumps_changed(bool)


# func apply_prolonged_effect(player: Player, effect: ProlongedEffect) -> void:
# 	effect.apply(player)
# 
# func apply_instant_effect(player: Player, effect: InstantEffect) -> void:
# 	effect.apply(player)

##################################################
# This section is designated for all bool effects
# Stack is implemented due to on/off nature of boolean
# Suppose effects e1 and e2
# e1.on -> e2.on -> e1.off -> e2.off
#                   ^ at this point effect should be on
# but it is not because e1 turns of effect
# So stack solves that problem
# Others should not be a problem, I suppose
##################################################

var disable_jump_stack := 0
@export var disable_jump := false:
	set(v):
		if v: disable_jump_stack += 1
		else: disable_jump_stack = max(disable_jump_stack - 1, 0)
		var disabled := disable_jump_stack > 0
		if disable_jump != disabled:
			disable_jump = disabled
			disable_jump_changed.emit(v)

var disable_dash_stack := 0
@export var disable_dash := false:
	set(v):
		if v: disable_dash_stack += 1
		else: disable_dash_stack = max(disable_dash_stack - 1, 0)
		var disabled := disable_dash_stack > 0
		if disable_dash != disabled:
			disable_dash = disabled
			disable_dash_changed.emit(v)

var disable_move_stack := 0
@export var disable_move := false:
	set(v):
		if v: disable_move_stack += 1
		else: disable_move_stack = max(disable_move_stack - 1, 0)
		var disabled := disable_move_stack > 0
		if disable_move != disabled:
			disable_move = disabled
			disable_move_changed.emit(v)

var disable_move_camera_stack := 0
@export var disable_move_camera := false:
	set(v):
		if v: disable_move_camera_stack += 1
		else: disable_move_camera_stack = max(disable_move_camera_stack - 1, 0)
		var disabled := disable_move_camera_stack > 0
		if disable_move_camera != disabled:
			disable_move_camera = disabled
			disable_move_camera_changed.emit(v)

var disable_change_slot_stack := 0
@export var disable_change_slot := false:
	set(v):
		if v: disable_change_slot_stack += 1
		else: disable_change_slot_stack = max(disable_change_slot_stack - 1, 0)
		var disabled := disable_change_slot_stack > 0
		if disable_change_slot != disabled:
			disable_change_slot = disabled
			disable_change_slot_changed.emit(v)

var immortal_stack := 0
@export var immortal := false:
	set(v):
		if v: immortal_stack += 1
		else: immortal_stack = max(immortal_stack - 1, 0)
		var disabled := immortal_stack > 0
		if immortal != disabled:
			immortal = disabled
			immortal_changed.emit(v)

var disable_item_stack := 0
@export var disable_item := false:
	set(v):
		if v: disable_item_stack += 1
		else: disable_item_stack = max(disable_item_stack - 1, 0)
		var disabled := disable_item_stack > 0
		if disable_item != disabled:
			disable_item = disabled
			disable_item_changed.emit(v)

var infinite_jumps_stack := 0
@export var infinite_jumps := false:
	set(v):
		if v: infinite_jumps_stack += 1
		else: infinite_jumps_stack = max(infinite_jumps_stack - 1, 0)
		var disabled := infinite_jumps_stack > 0
		if infinite_jumps != disabled:
			infinite_jumps = disabled
			infinite_jumps_changed.emit(v)
