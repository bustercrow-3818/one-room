extends Button

@export var cost: int
@export_multiline var tooltip_body: String

func initialize() -> void:
	connect_signals()
	update_tooltip()

func connect_signals() -> void:
	pressed.connect(cost_check)

func cost_check() -> void:
	SignalBus.cost_check.emit(self, cost)

func cost_approved() -> void:
	SignalBus.discard_waiting.emit()

func update_tooltip() -> void:
	tooltip_text = ("Cost: %s \n" % cost) + tooltip_body
