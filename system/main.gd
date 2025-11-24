extends Node2D

var room_ready: bool = true
var error_messages: Array[String]

func _ready() -> void:
	connect_signals()
	propagate_call("initialize", [], true)

func connect_signals() -> void:
	%Button.pressed.connect(SignalBus.round_start.emit)
	%Button.pressed.connect(ready_check)
	
func set_goals() -> void:
	%MobHandler.set_goals(%GoalHandler.get_goals())

func ready_check() -> void:
	for i in get_tree().get_nodes_in_group("handler"):
		if i.is_ready_for_round():
			round_start()
		elif i.is_ready_for_round() == false:
			for j in error_messages:
				print(j)
			return

func round_start() -> void:
	set_goals()
	%MobHandler.start_round()
