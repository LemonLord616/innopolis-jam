@abstract
extends Node
class_name State


signal entered(state: State) # self
signal exited(state: State) # self

signal switch_to_state(from: State, to: State)
signal enter_state(state: State)
signal exit_state(state: State)
signal switch_to_states(from: State, to: Array[State])
signal enter_states(states: Array[State])
signal exit_states(states: Array[State])

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)

func _enter() -> bool:
	set_process(true)
	set_physics_process(true)
	enter()
	Logging.debug(self, "entered")
	entered.emit(self)
	return true

func _exit() -> bool:
	set_process(false)
	set_physics_process(false)
	exit()
	Logging.debug(self, "exited")
	exited.emit(self)
	return true

@abstract
func enter() -> void
@abstract
func exit() -> void
