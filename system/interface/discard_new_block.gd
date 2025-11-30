extends Button

@export var cost: int

func initialize() -> void:
	connect_signals()

func connect_signals() -> void:
	pressed.connect(cost_check)

func cost_check() -> void:
	SignalBus.cost_check.emit(self, cost)

func cost_approved() -> void:
	SignalBus.discard_waiting.emit()
