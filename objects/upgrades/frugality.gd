extends Upgrade

var current_bonus: int = 0
var is_frugal: bool = false

func on_purchase() -> void:
	SignalBus.approved_purchase.connect(reset_bonus)
	SignalBus.round_start.connect(round_start)
	SignalBus.end_of_round.connect(end_of_round)

func round_start() -> void:
	if is_frugal:
		add_bonus()

func end_of_round() -> void:
	is_frugal = true
	player.adjust_bits(current_bonus)

func add_bonus() -> void:
	current_bonus += 1
	
func reset_bonus(_unhandled_input) -> void:
	is_frugal = false
	current_bonus = 0
