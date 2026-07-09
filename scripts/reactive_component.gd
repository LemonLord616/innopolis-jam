@abstract
extends Component
class_name ReactiveComponent

signal triggered
signal executed
signal interrupted

var _interrupted := false

func trigger() -> bool:
	_interrupted = false
	triggered.emit()
	if _interrupted:
		interrupted.emit()
		return false
	execute()
	executed.emit()
	return true

func interrupt() -> void:
	_interrupted = true

@abstract
func execute() -> void
