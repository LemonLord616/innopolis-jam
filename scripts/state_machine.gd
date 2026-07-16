extends Node
class_name StateMachine


@export var initial_states: Array[State]


func _ready() -> void:
	for state in initial_states:
		_on_enter_state(state)


func _on_switch_to_state(from: State, to: State) -> void:
	_on_exit_state(from)
	_on_enter_state(to)
func _on_switch_to_states(from: State, to: Array[State]) -> void:
	_on_exit_state(from)
	_on_enter_states(to)

func _on_enter_state(state: State) -> void:
	if state.active:
		return
	state.switch_to_state.connect(_on_switch_to_state)
	state.switch_to_states.connect(_on_switch_to_states)
	state.enter_state.connect(_on_enter_state)
	state.enter_states.connect(_on_enter_states)
	state.exit_state.connect(_on_exit_state)
	state.exit_states.connect(_on_exit_states)
	state._enter()
	# Logging.debug(self, "entered: " + state.name)

func _on_enter_states(states: Array[State]) -> void:
	for state in states:
		_on_enter_state(state)


func _on_exit_state(state: State) -> void:
	if not state.active:
		return
	state.switch_to_state.disconnect(_on_switch_to_state)
	state.switch_to_states.disconnect(_on_switch_to_states)
	state.enter_state.disconnect(_on_enter_state)
	state.enter_states.disconnect(_on_enter_states)
	state.exit_state.disconnect(_on_exit_state)
	state.exit_states.disconnect(_on_exit_states)
	state._exit()
	# Logging.debug(self, "exited: " + state.name)

func _on_exit_states(states: Array[State]) -> void:
	for state in states:
		_on_exit_state(state)
