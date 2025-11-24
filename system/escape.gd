extends Node2D



@onready var detection: Area2D = $Area2D

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	detection.body_entered.connect(escape_reached)
	pass
	
func escape_reached(body: Node2D) -> void:
	if body is Mob:
		SignalBus.escape_reached.emit()
	else:
		pass
