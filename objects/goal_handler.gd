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

func get_goals() -> Array[Vector2]:
	var goals: Array[Vector2]
	
	for i in get_children():
		goals.append(i.position)
	
	return goals
