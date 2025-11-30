extends Node2D
class_name Player

@export var bits: int = 0
@export var score_display: Label

func initialize() -> void:
	connect_signals()

func connect_signals() -> void:
	SignalBus.round_start.connect(round_start)
	SignalBus.end_of_round.connect(end_of_round)
	SignalBus.bits_spent.connect(adjust_bits)
	SignalBus.goal_cleanup.connect(adjust_bits)
	SignalBus.cost_check.connect(process_cost_check)

func round_start() -> void:
	disable_buttons(true)
	
func end_of_round() -> void:
	disable_buttons(false)

func adjust_bits(qty: int) -> void:
	bits += qty
	score_display.text = str(bits)
	
	if qty != 0 and bits <= 0:
		disable_buttons(true)
	
func get_current_bits() -> int:
	return bits

func disable_buttons(state: bool) -> void:
	for i in get_tree().get_nodes_in_group("buttons"):
		if i is Button:
			i.disabled = state

func process_cost_check(id: Node, cost: int) -> void:
	if cost >= bits:
		game_over()
		return
	else:
		id.cost_approved()
		adjust_bits(-cost)

func game_over() -> void:
	bits = 0
	disable_buttons(true)
	score_display.text = str(bits)
	SignalBus.game_over.emit()
