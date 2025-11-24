extends Node2D

var room_ready: bool = true
var error_messages: Array[String]

func _ready() -> void:
	connect_signals()
	propagate_call("initialize", [], true)

func connect_signals() -> void:
	%Button.pressed.connect(ready_check)
	
func set_goals() -> void:
	%MobHandler.set_goals(%GoalHandler.get_goals())

func ready_check() -> void:
	for i in get_tree().get_nodes_in_group("handler"):
		if i.is_ready_for_round():
			print("all clear, proceeding with round")
			pass
		elif i.is_ready_for_round() == false:
			print("found a problem, should not proceed")
			return
	
	round_start()

func round_start() -> void:
	SignalBus.round_start.emit()
	set_goals()
	%MobHandler.start_round()
