extends Node

enum ScopeMode { HOLD, TOGGLE }

var consumable_interruptible := true
var scope_mode := ScopeMode.TOGGLE
