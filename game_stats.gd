extends Node

var rounds_completed: int = 0
var blocks_placed: int = 0
var blocks_discarded: int = 0

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	
	pass

func initialize_stats() -> void:
	rounds_completed = 0
	blocks_placed = 0
	blocks_discarded = 0
