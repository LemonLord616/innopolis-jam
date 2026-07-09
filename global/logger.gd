extends Node
class_name Logging


enum LoggingLevel {
	DEBUG, INFO, WARNING, ERROR, NOLOGGING
}
static var logging_level = LoggingLevel.DEBUG

static func _caller_name(from: Node) -> String:
	if not from:
		return "null"
	return from.name

static func debug(from: Node, msg: String):
	if logging_level > LoggingLevel.DEBUG:
		return
	print("[DEBUG][%s] %s" % [_caller_name(from), msg])

static func info(from: Node, msg: String):
	if logging_level > LoggingLevel.INFO:
		return
	print("[INFO][%s] %s" % [_caller_name(from), msg])

static func warning(from: Node, msg: String):
	if logging_level > LoggingLevel.WARNING:
		return
	var message := "[WARNING][%s] %s" % [_caller_name(from), msg]
	print(message)
	push_warning(message)

static func error(from: Node, msg: String):
	if logging_level > LoggingLevel.ERROR:
		return
	var message := "[ERROR][%s] %s" % [_caller_name(from), msg]
	print(message)
	push_error(message)
