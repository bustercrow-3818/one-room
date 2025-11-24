extends Node2D

@export var player: Player

var ready_for_round: bool = true
var active_goals: Array[Node2D]

func initialize() -> void:
	connect_signals()
	for i in get_children():
		if i.has_method("initialize"):
			i.initialize()
			active_goals.append(i)
		else:
			pass
	
func connect_signals() -> void:
	SignalBus.escape_reached.connect(end_round_cleanup)
	pass

func get_goals() -> Array[Vector2]:
	var goals: Array[Vector2]
	
	for i in get_children():
		goals.append(i.position)
	
	return goals

func is_ready_for_round() -> bool:
	return ready_for_round

func end_round_cleanup() -> void:
	for i in active_goals:
		player.adjust_money(2)
		
	active_goals.clear()
	pass
