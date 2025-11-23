extends Node2D

func _ready() -> void:
	connect_signals()
	
	%MobHandler.set_goals(%GoalHandler.get_goals())
	
	propagate_call("initialize", [], true)

func connect_signals() -> void:
	%Button.pressed.connect(SignalBus.round_start.emit)
