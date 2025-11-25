extends Node2D

var ready_for_round: bool = false
var unplaced_blocks: Array[StaticBody2D]

func initialize() -> void:
	for i in get_children():
		if i is StaticBody2D:
			unplaced_blocks.append(i)
	connect_signals()
	
func connect_signals() -> void:
	
	pass

func is_ready_for_round() -> bool:
	return ready_for_round
