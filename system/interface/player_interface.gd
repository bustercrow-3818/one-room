extends Node2D
class_name Player

@export_category("Process Attributes")
@export_range(0, 2, 0.01) var interface_flash_duration: float
@export_color_no_alpha var good_flash_color: Color
@export_color_no_alpha var bad_flash_color: Color

@export_category("Node References")
@export var bits: int = 0
@export var score_display: Label
@export var discard_button: Button

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

func adjust_discard_cost(qty: int) -> void:
	discard_button.cost += qty
	discard_button.update_tooltip()

func adjust_bits(qty: int) -> void:
	bits += qty
	score_display.text = str(bits)

func get_current_discard_cost() -> int:
	return discard_button.cost

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
		SignalBus.approved_purchase.emit(id)
		id.cost_approved()
		adjust_bits(-cost)

func game_over() -> void:
	bits = 0
	disable_buttons(true)
	score_display.text = str(bits)
	SignalBus.game_over.emit()

func interface_flash(piece: Control, color: Color) -> void:
	var tween: Tween = create_tween()
	var original_color: Color = piece.modulate
	
	tween.tween_property(piece, "self_modulate", color, interface_flash_duration / 2)
	tween.tween_property(piece, "self_modulate", original_color, interface_flash_duration / 2)
