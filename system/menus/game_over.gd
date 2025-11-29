extends Control

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	%try_again_button.pressed.connect(%button_sound.play)
	%try_again_button.pressed.connect(hide)
	%try_again_button.pressed.connect(new_game)
	
func game_over() -> void:
	update_rounds_complete()
	show()
	%voice.play()

func update_rounds_complete() -> void:
	%rounds_complete_report.text = "Highest Round Completed:\n Round " + str(GameStats.rounds_completed)

func new_game() -> void:
	get_tree().reload_current_scene()
