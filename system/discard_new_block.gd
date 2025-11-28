extends Button

@export var cost: int
@export var player: Player


func initialize() -> void:
	connect_signals()

func connect_signals() -> void:
	pressed.connect(discard)

func discard() -> void:
	if player.get_current_money() >= cost:
		player.adjust_money(-cost)
		SignalBus.discard_block.emit()
		
