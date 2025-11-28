extends Node2D
class_name Player

@export var money: int = 0
@export var score_display: Label

func initialize() -> void:
	connect_signals()
	adjust_money(0)

func connect_signals() -> void:
	SignalBus.round_start.connect(round_start)
	SignalBus.end_of_round.connect(end_of_round)
	pass

func round_start() -> void:
	disable_buttons(true)
	
func end_of_round() -> void:
	disable_buttons(false)

func adjust_money(qty: int) -> void:
	money += qty
	score_display.text = str(money)
	
	if qty != 0 and money <= 0:
		disable_buttons(true)
	
func get_current_money() -> int:
	return money

func disable_buttons(state: bool) -> void:
	for i in get_tree().get_nodes_in_group("buttons"):
		if i is Button:
			i.disabled = state
