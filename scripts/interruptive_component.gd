@abstract
extends Component
class_name InterruptiveComponent

signal interrupted

var _interrupted := false

func interrupt() -> void:
	Logging.debug(self, "interrupted")
	interrupted.emit()
	_interrupted = true
