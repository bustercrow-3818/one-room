extends Upgrade

@export_category("Snake Oil")
@export var end_round_bits: int = 1
@export var increased_glitch_coefficient: float = 1.5

func on_purchase() -> void:
	SignalBus.end_of_round.connect(end_round_bonus)
	block_handler.glitch_chance *= increased_glitch_coefficient
	block_handler.glitch_chance += 0.01

func end_round_bonus() -> void:
	player.adjust_bits(end_round_bits)
