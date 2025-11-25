extends StaticBody2D
class_name Block

var block_placed_status: bool = false

func initialize() -> void:
	connect_signals()
	
func connect_signals() -> void:
	
	pass

func is_block_placed() -> bool:
	return block_placed_status

func block_placed() -> void:
	block_placed_status = true
