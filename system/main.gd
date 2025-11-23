extends Node2D

var room_ready: bool = true
var error_messages: Array[String]

func _ready() -> void:
	connect_signals()
	propagate_call("initialize", [], true)

func connect_signals() -> void:
	%Button.pressed.connect(SignalBus.round_start.emit)
	%Button.pressed.connect(round_start)
	
	SignalBus.not_ready.connect(add_error_message)
	
func set_goals() -> void:
	%MobHandler.set_goals(%GoalHandler.get_goals())

func round_start() -> void:
	if room_ready:
		set_goals()
		%MobHandler.start_round()
	else:
		for i in error_messages:
			print(i)

func add_error_message(message: String) -> void:
	room_ready = false
	error_messages.append(message)

func clear_error_message(message: String) -> void:
	if error_messages.has(message):
		error_messages.erase(message)
	
	if error_messages.is_empty():
		room_ready_restored()

func room_ready_restored() -> void:
	print("Ready for next round")
	room_ready = true
