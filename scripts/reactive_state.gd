@abstract
extends State
class_name ReactiveState


signal triggered(state: State)
signal executed(state: State)

func trigger() -> bool:
	_interrupted = false
	triggered.emit()
	if _interrupted:
		interrupted.emit(self)
		return false
	execute()
	executed.emit()
	return true

@abstract
func execute() -> void
