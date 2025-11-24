extends Node2D

var ready_for_round: bool = true

func initialize() -> void:
	connect_signals()
	for i in get_children():
		if i.has_method("initialize"):
			i.initialize()
		else:
			pass
	
func connect_signals() -> void:
	
	pass

func is_ready_for_round() -> bool:
	return ready_for_round
