extends Button

@export var cost: int = 20
@export var player: Player


func initialize() -> void:
	connect_signals()

func connect_signals() -> void:
	pressed.connect(discard)

func discard() -> void:
	if player.get_current_money() >= 20:
		player.adjust_money(-20)
		SignalBus.discard_block.emit()
		
