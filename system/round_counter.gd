extends Label

func update_display() -> void:
	text = "Round " + str(GameStats.rounds_completed + 1)
	
