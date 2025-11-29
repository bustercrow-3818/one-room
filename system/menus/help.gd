extends Control



func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	%dismiss_help.pressed.connect(hide)
	pass
