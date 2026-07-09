@abstract
extends State
class_name InterruptiveState


signal entering(state: State) # self
signal exiting(state: State) # self

signal interrupted(state: State) # self

var _interrupted := false

func interrupt() -> void:
	Logging.debug(self, "interrupted")
	interrupted.emit()
	_interrupted = true

func _enter() -> bool:
	Logging.debug(self, "entering")
	_interrupted = false
	entering.emit(self)
	if _interrupted:
		interrupted.emit()
		return false
	set_process(true)
	set_physics_process(true)
	enter()
	Logging.debug(self, "entered")
	entered.emit(self)
	return true

func _exit() -> bool:
	Logging.debug(self, "exiting")
	_interrupted = false
	exiting.emit(self)
	if _interrupted:
		interrupted.emit()
		return false
	set_process(false)
	set_physics_process(false)
	exit()
	Logging.debug(self, "exited")
	exited.emit(self)
	return true
