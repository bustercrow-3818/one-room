extends Node2D

@export_category("Node References")
@export var help_message: Control
@export var game_over_screen: Control
@export var round_counter: Label
@export var upgrade_handler: UpgradeHandler



var room_ready: bool = true
var error_messages: Array[String]

func _ready() -> void:
	connect_signals()
	propagate_call("initialize", [], true)
	

func connect_signals() -> void:
	%start_round.pressed.connect(ready_check)
	%start_round.pressed.connect(%button_sound.play)
	%show_help.pressed.connect(help_message.show)
	%show_help.pressed.connect(%button_sound.play)
	SignalBus.end_of_round.connect(end_of_round)
	SignalBus.discarding_complete.connect(game_over)
	
func set_goals() -> void:
	%MobHandler.set_goals(%GoalHandler.get_goals())

func ready_check() -> void:
	for i in get_tree().get_nodes_in_group("handler"):
		if i.is_ready_for_round():
			pass
		elif i.is_ready_for_round() == false:
			return
	
	round_start()

func round_start() -> void:
	SignalBus.round_start.emit()
	set_goals()
	%MobHandler.start_round()

func end_of_round() -> void:
	%round_over_sound.play()
	GameStats.rounds_completed += 1
	round_counter.update_display()
	pass

func game_over() -> void:
	round_counter.update_display()
	game_over_screen.game_over()
	pass
