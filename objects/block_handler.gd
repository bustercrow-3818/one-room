extends Node2D

func initialize() -> void:
	connect_signals()
	for i in get_children():
		if i.has_method("initialize"):
			i.initialize()
		else:
			pass
	
func connect_signals() -> void:
	
	pass
