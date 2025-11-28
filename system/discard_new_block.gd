extends Button

@export var cost: int
@export var player: Player


func initialize() -> void:
	connect_signals()

func connect_signals() -> void:
	pressed.connect(discard)

func discard() -> void:
	if cost >= player.get_current_money():
		SignalBus.game_over.emit()
	else:
		SignalBus.discard_block.emit()
	player.adjust_money(-cost)
		
