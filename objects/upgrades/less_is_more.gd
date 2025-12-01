extends Upgrade

func initialize() -> void:
	super()
	
func on_purchase() -> void:
	if block_handler.new_round_block_qty > 1:
		block_handler.new_round_block_qty -= 1
	
	player.adjust_discard_cost(player.get_current_discard_cost())
