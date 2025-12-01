extends Upgrade

@export_category("Vaccinate")
@export var additional_blocks: int = 1

func on_purchase() -> void:
	block_handler.glitch_chance = 0
	block_handler.new_round_block_qty += additional_blocks
